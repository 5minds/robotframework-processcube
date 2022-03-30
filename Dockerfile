FROM python:3

WORKDIR /robot

RUN pip install --upgrade pip

# @Robin mach' hinne
RUN pip install robotframework robotframework-jsonlibrary robotframework-processcube==1.3.6

CMD robot **/*.robot
