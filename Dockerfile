FROM python:3

WORKDIR /robot

RUN pip install --upgrade pip

RUN pip install robotframework robotframework-jsonlibrary robotframework-processcube

CMD robot **/*.robot
