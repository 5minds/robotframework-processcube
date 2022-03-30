FROM python:3.9

WORKDIR /robot

RUN apt update

RUN apt install -y chromium chromium-driver xvfb sudo

RUN pip install --upgrade pip

RUN pip install cython --upgrade
RUN pip install numpy --upgrade

RUN pip install robotframework robotframework-jsonlibrary robotframework-processcube QWeb

RUN groupadd -r robot && useradd --no-log-init -r -g robot robot

RUN xvfb-run --auto-servernum --server-num=1 xvfb

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

CMD robot **/*.robot
