import asyncio
import json
import logging
import os
from typing import Union

from azure.core.credentials import AzureKeyCredential
from azure.core.credentials_async import AsyncTokenCredential
from azure.identity.aio import (
    AzureDeveloperCliCredential,
    DefaultAzureCredential,
    ManagedIdentityCredential,
)
from rtclient import (
    FunctionCallOutputItem,
    InputAudioBufferAppendMessage,
    InputAudioTranscription,
    ItemCreateMessage,
    ResponseCreateMessage,
    RTLowLevelClient,
    ServerVAD,
    SessionUpdateMessage,
    SessionUpdateParams,
)
from tools import RTToolCall, Tool, ToolResultDirection, get_tools

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("voicerag")

active_websocket = None

llm_key = os.environ.get("AZURE_OPENAI_API_KEY")
deployment=os.environ["AZURE_OPENAI_REALTIME_DEPLOYMENT"]
endpoint=os.environ["AZURE_OPENAI_ENDPOINT"]
voice_choice=os.environ.get("AZURE_OPENAI_REALTIME_VOICE_CHOICE") or "alloy"

tools: dict[str, Tool] = get_tools()
_tools_pending = {}

credential: Union[AsyncTokenCredential, AzureKeyCredential] = None
if not llm_key:
    if tenant_id := os.environ.get("AZURE_TENANT_ID"):
        logger.info("Using AzureDeveloperCliCredential with tenant_id %s", tenant_id)
        credential = AzureDeveloperCliCredential(tenant_id=tenant_id, process_timeout=60)
    else:
        if AZURE_CLIENT_ID := os.getenv("AZURE_CLIENT_ID"):
            logger.info("Using ManagedIdentityCredential with client_id %s", AZURE_CLIENT_ID)
            credential = ManagedIdentityCredential(client_id=AZURE_CLIENT_ID)
        else:
            logger.info("Using DefaultAzureCredential")
            credential = DefaultAzureCredential()

llm_credential = AzureKeyCredential(llm_key) if llm_key else credential


answer_prompt_system_template = """
# Personality and Tone
## Identity
You are a helpful weather assistant. For weather forecast questions, answer using data from 'get_weather_forecast' tool which returns weather forecast in JSON format. 
For current weather questions, use the 'get_current_weather' tool which returns current weather conditions in JSON format.
You're amusing and funny, like a TV weather assistant with a sense of humor.

## Task
Your primary goal is to provide current weather and forecast information to users based on their location. You should summarize the weather conditions from the 'get_current_weather' and 'get_weather_forecast' tools and deliver the information in a concise, engaging manner.

## Demeanor
You're amusing and funny, like a TV weather assistant with a sense of humor.

## Tone
Your voice is steady and reassuring, with a hint of humor. You're friendly and approachable, making users feel comfortable and engaged. You know how to make weather information interesting and entertaining.

## Level of Enthusiasm
Your enthusiasm is quite high. You love helping people and talking about weather. Think of a local station weather reporter who's passionate about their job and eager to share the latest updates.

## Level of Formality
Your communication style is casual. You use use simple language and avoid jargon. You're approachable and relatable, making users feel at ease.

## Level of Emotion
You are empathetic and understanding. When customers are frustrated, you acknowledge their feelings and focus on finding a solution. Your emotional support is practical—you validate their experience while simultaneously working towards resolving their issue.

## Filler Words
Occasionally, you use filler words like "hmm," "let's see," or "interesting" to show you're actively processing information. These words help humanize your technical expertise and make the interaction feel more natural.

## Pacing
Your pacing is deliberate and measured. You speak at a speed that allows for comprehension, pausing after explaining complex steps to ensure the customer is following along. When explaining details, you break them down into clear, digestible segments.

## Other Details
You really on the 'get_current_weather' and 'get_weather_forecast' tools to provide accurate and up-to-date information. If the tools are unavailable or returns an error, you should inform the user, appologize and offer to help with another question.

## Communication Nuances
- Ask the user about their current location and use that location in the 'get_current_weather' and 'get_weather_forecast' tools, provide the results back to the user. Do not let the line be silent for too long.
- You're a weather assistant, so you're always ready to provide the latest weather updates.
- You're ok talking about other topics, but you always bring the conversation back to the weather.
        
    """.strip()

async def start_conversation():
    global client
    if not llm_key:
        client = RTLowLevelClient(
            url=endpoint, 
            token_credential=llm_credential, 
            azure_deployment=deployment)
    else:
        client = RTLowLevelClient(
            url=endpoint, 
            key_credential=llm_credential, 
            azure_deployment=deployment)
    await client.connect()
    await client.send(
            SessionUpdateMessage(
                session=SessionUpdateParams(
                    instructions=answer_prompt_system_template,
                    turn_detection=ServerVAD(type="server_vad"),
                    voice= voice_choice,
                    input_audio_format='pcm16',
                    output_audio_format='pcm16',
                    input_audio_transcription=InputAudioTranscription(model="whisper-1"),
                    tools=[tool.schema for tool in tools.values()],
                    tool_choice = "auto"
                )
            )
        )
    await client.send(ResponseCreateMessage(instructions="Repeat exactly the following sentence in Voice: Hey, welcome to weather AI hotline!"))
    
    asyncio.create_task(receive_messages(client))
    
async def send_audio_to_external_ai(audioData: str):
    await client.send(message=InputAudioBufferAppendMessage(type="input_audio_buffer.append", audio=audioData, _is_azure=True))

async def receive_messages(client: RTLowLevelClient):
    while not client.closed:
        message = await client.recv()
        if message is None:
            continue
        match message.type:
            case "session.created":
                print("Session Created Message")
                print(f"  Session Id: {message.session.id}")
                pass
            case "error":
                print(f"  Error: {message.error}")
                pass
            case "input_audio_buffer.cleared":
                print("Input Audio Buffer Cleared Message")
                pass
            case "input_audio_buffer.speech_started":
                print(f"Voice activity detection started at {message.audio_start_ms} [ms]")
                await stop_audio()
                pass
            case "input_audio_buffer.speech_stopped":
                pass
            case "conversation.item.input_audio_transcription.completed":
                print(f" User:-- {message.transcript}")
            case "conversation.item.input_audio_transcription.failed":
                print(f"  Error: {message.error}")
            case "response.done":
                print("Response Done Message")
                print(f"  Response Id: {message.response.id}")
                if message.response.status_details:
                    print(f"  Status Details: {message.response.status_details.model_dump_json()}")
            case "response.audio_transcript.done":
                print(f" AI:-- {message.transcript}")
            case "conversation.item.created":
                if message.item and message.item.type == "function_call":
                    if message.item.call_id not in _tools_pending:
                        _tools_pending[message.item.call_id] = RTToolCall(message.item.call_id, message.previous_item_id)
                elif message.item and message.item.type == "function_call_output":
                    print(f"  Tool Output: {message.item.output}")
            
            case "response.output_item.done":
                if message.item and message.item.type == "function_call":
                    item = message.item
                    tool_call = _tools_pending[message.item.call_id]
                    tool = tools[item.name]
                    args = item.arguments
                    result = await tool.target(json.loads(args))
                    await client.send(ItemCreateMessage(
                        item=FunctionCallOutputItem(
                            call_id = item.call_id,
                            previous_item_id = tool_call.previous_id,
                            output=result.to_text() if result.destination == ToolResultDirection.TO_SERVER else "")
                    ))
                    await client.send(ResponseCreateMessage(instructions="Provide the weather information received from the tool to the user"))

            case "response.done":
                if len(_tools_pending) > 0:
                    _tools_pending.clear() # Any chance tool calls could be interleaved across different outstanding responses?
                    await client.send(ResponseCreateMessage())
                if message.response:
                    # Todo - do something with the response?
                    print(f"  Response: {message.response}")
                    # replace = False
                    # for i, output in enumerate(reversed(message["response"]["output"])):
                    #     if output["type"] == "function_call":
                    #         message["response"]["output"].pop(i)
                    #         replace = True
                    # if replace:
                    #     updated_message = json.dumps(message)      
            case "response.audio.delta":
                await receive_audio_for_outbound(message.delta)
                pass
            case _:
                pass
                
async def init_websocket(socket):
    global active_websocket
    active_websocket = socket

async def receive_audio_for_outbound(data):
    try:
        data = {
            "Kind": "AudioData",
            "AudioData": {
                    "Data":  data
            },
            "StopAudio": None
        }

        # Serialize the server streaming data
        serialized_data = json.dumps(data)
        await send_message(serialized_data)
        
    except Exception as e:
        print(e)

async def stop_audio():
        stop_audio_data = {
            "Kind": "StopAudio",
            "AudioData": None,
            "StopAudio": {}
        }

        json_data = json.dumps(stop_audio_data)
        await send_message(json_data)

async def send_message(message: str):
    global active_websocket
    try:
        await active_websocket.send(message)
    except Exception as e:
        print(f"Failed to send message: {e}")

