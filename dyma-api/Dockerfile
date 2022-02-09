FROM python:3.8
# FROM python:3.9-slim
# FROM python:3.8-slim-buster
# FROM python:3.7-alpine

ENV PYTHONUNBUFFERED True

ENV APP_HOME /app

WORKDIR $APP_HOME

COPY . ./

RUN pip3 install -r requirements.txt

ENV PROJECT_ENV dev

CMD python3 main.py runserver 0.0.0.0:$PORT
