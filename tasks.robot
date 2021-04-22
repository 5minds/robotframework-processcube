*** Settings ***
Documentation   Template robot main suite.
Library         Collections

Library         AtlasEngineClient.py     http://localhost:56100
#Library         AtlasEngineClient.py    self_hosted_engine = docker
#Library         AtlasEngineClient.py    self_hosted_engine = node

*** Variables ***
${CORRELATION}    -1

*** Tasks ***
Get engine info task
    ${INFO}               Get Engine Info
    Log                   ${INFO}

*** Tasks ***
Deploy a process
    Deploy Process    hello_robot_framework.bpmn


*** Tasks ***
Start process with payload
    &{PAYLOAD}=           Create Dictionary        foo=bar    hello=world
    ${PROCESS}=           Start Process            hello_robot_framework    ${PAYLOAD}
    Set Suite Variable    ${CORRELATION}           ${PROCESS.process_instance_id}
    Should Be True        '${PROCESS.token_payload["hello"]}' == 'world2'

*** Tasks ***
Get User Task by correlation_id
    Log                   ${CORRELATION}
    ${USER_TASK}=         Get User Task By        process_instance_id=${CORRELATION}
    Log                   ${USER_TASK}

*** Tasks ***
Get User Task
    Log                   ${CORRELATION}
    ${USER_TASK}=         Get User Task By
    Log                   ${USER_TASK}
