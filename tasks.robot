*** Settings ***
Documentation   Template robot main suite.
Library         AtlasEngineClient.py    http://localhost:56100
Library         Collections

*** Variables ***
${CORRELATION}    -1
${USER_TASK}      -1

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
    ${PROCESS}            Start Process            hello_robot_framework    ${PAYLOAD}
    ${CORRELATION}=       Set Variable             ${PROCESS.correlation_id}
    Should Be True        '${PROCESS.token_payload["hello"]}' == 'world'

*** Tasks ***
Get User Task by Correlation
    Log                   ${CORRELATION}
    ${USER_TASK}          Set Variable    Get User Task By Correlation    ${CORRELATION}
    Log                   ${USER_TASK}

*** Tasks ***
Get User Task
    Log                   ${CORRELATION}
    ${USER_TASK}          Set Variable    Get User Task    correlation_id=${CORRELATION}
    Log                   ${USER_TASK}
