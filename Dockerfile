FROM python:3.12.7

ARG PROCESS_CUBE_LIBRARY_VERSION

WORKDIR /robot

RUN pip install --upgrade pip setuptools wheel

RUN pip install aiohttp --no-binary :all:

RUN pip install robotframework-processcube==${PROCESS_CUBE_LIBRARY_VERSION}

CMD robot **/*.robot
