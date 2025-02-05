FROM python:3.12-slim

WORKDIR /app
COPY . /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN python -m pip install --upgrade pip && \
    python -m pip install -r requirements.txt
RUN python -m pip install ./aoai-whl/rtclient-0.5.3-py3-none-any.whl gunicorn


CMD ["python3", "main.py"]
