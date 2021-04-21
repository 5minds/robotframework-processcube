*** Settings ***
Documentation   Template robot main suite.
Library         AtlasEngineClient.py    http://localhost:56100


*** Tasks ***
Get engine info task
    ${INFO}    Get Engine Info
    Log    ${INFO}


*** Tasks ***
Deploy a process model
    Deploy By Pathname    hello_robot_framework.bpmn


*** Tasks ***
Start process with payload
    &{PAYLOAD} =    Create Dictionary    foo    bar    hello    world
    ${RESULT}    Start Process     hello_robot_framework    ${PAYLOAD}
    Log    ${RESULT.token_payload}
    Should Be True    '${RESULT.token_payload["hello"]}'=='world'
