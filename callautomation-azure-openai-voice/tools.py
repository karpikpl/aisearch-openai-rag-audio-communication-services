import json
from enum import Enum
from logging import info
from typing import Any, Callable, Literal

import aiohttp


class ToolResultDirection(Enum):
    TO_SERVER = 1
    TO_CLIENT = 2

class ToolResult:
    text: str
    destination: ToolResultDirection

    def __init__(self, text: str, destination: ToolResultDirection):
        self.text = text
        self.destination = destination

    def to_text(self) -> str:
        if self.text is None:
            return ""
        return self.text if isinstance(self.text, str) else json.dumps(self.text)

class RTToolCall:
    tool_call_id: str
    previous_id: str

    def __init__(self, tool_call_id: str, previous_id: str):
        self.tool_call_id = tool_call_id
        self.previous_id = previous_id

class Tool:
    target: Callable[..., ToolResult]
    schema: Any

    def __init__(self, target: Any, schema: Any):
        self.target = target
        self.schema = schema

_weather_forecast_tool_schema = {
    "name": "get_weather_forecast",
    "type": "function",
    "description": "Retrieves the 7-day weather forecast for a given lat, lng coordinate pair. Specify a label for the location.",
    "parameters": {
      "type": "object",
      "properties": {
        "lat": {
          "type": "number",
          "description": "Latitude",
        },
        "lng": {
          "type": "number",
          "description": "Longitude",
        },
        "location": {
          "type": "string",
          "description": "Name of the location",
        },
      },
      "required": ["lat", "lng", "location"],
      "additionalProperties": False
    },
  }

_weather_current_tool_schema = {
    "name": "get_current_weather",
    "type": "function",
    "description": "Retrieves the current weather for a given lat, lng coordinate pair. Specify a label for the location.",
    "parameters": {
      "type": "object",
      "properties": {
        "lat": {
          "type": "number",
          "description": "Latitude",
        },
        "lng": {
          "type": "number",
          "description": "Longitude",
        },
        "location": {
          "type": "string",
          "description": "Name of the location",
        },
      },
      "required": ["lat", "lng", "location"],
      "additionalProperties": False
    },
  }

async def _weather_tool(
    type: Literal["current", "hourly"],
    args: Any) -> ToolResult:

    info(f'Looking up current weather for "{args["location"]}".')
    
    url = "https://api.open-meteo.com/v1/forecast"
    data = { "error": "Failed to retrieve weather data" }
    params = {
        "latitude": args["lat"],
        "longitude": args["lng"],
        type: "temperature_2m,wind_speed_10m"
    }
    async with aiohttp.ClientSession() as session:
        async with session.get(url, params=params) as response:
            data = await response.json()

    info(f"Retrieved weather data: {data}")
    return ToolResult(json.dumps(data), ToolResultDirection.TO_SERVER)

def get_tools() -> dict[str, Tool]:
    
    return {
        "get_current_weather": Tool(schema=_weather_current_tool_schema, target=lambda args: _weather_tool('current', args)),
        "get_weather_forecast": Tool(schema=_weather_forecast_tool_schema, target=lambda args: _weather_tool('hourly', args))
    }