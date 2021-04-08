*** Settings ***
Documentation   Template robot main suite.
Resource        keywords.robot
Library         Library.py
Library         AtlasEngineClient.py    http://localhost:56100
Library    Process
Library    Collections
Variables       variables.py


*** Tasks ***
Example task
    Example Keyword
    Example Python Keyword

*** Tasks ***
Get engine info task
    ${INFO}    Get Engine Info
    Log    ${INFO}

*** Tasks ***
Deploy a process model
    Deploy Pathname    hello_robot_framework.bpmn

*** Tasks ***
Start process with payload
    &{PAYLOAD} =    Create Dictionary    foo    bar    hello    world
    ${RESULT}    Start Processmodel     hello_robot_framework    ${PAYLOAD}
    Log    ${RESULT["tokenPayload"]}
    Should Be True    '${RESULT["tokenPayload"]["hello"]}'=='world'

