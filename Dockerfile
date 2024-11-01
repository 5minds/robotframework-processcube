FROM python:3

ARG PROCESS_CUBE_LIBRARY_VERSION

WORKDIR /robot

RUN pip install --upgrade pip

RUN pip install robotframework-processcube==${PROCESS_CUBE_LIBRARY_VERSION}

CMD robot **/*.robot
