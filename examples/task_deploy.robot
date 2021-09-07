*** Variables ***
${CORRELATION}               -1
${USER_TASK_INSTANCE_ID}     -1
${EXTERNAL_TASK_ID}          -1
&{DOCKER_OPTIONS}            auto_remove=False

*** Settings ***
Documentation   Template robot main suite.
Library         Collections

Library         ProcessCubeLibrary     engine_url=http://localhost:56100    worker_id=my worker    max_retries=25
#Library          ProcessCubeLibrary    self_hosted_engine=docker    worker_id=my worker    docker_options=${DOCKER_OPTIONS}
#Suite Teardown   Engine Shutdown 

Metadata    RequirementsID    4612

*** Keywords ***
Deploy a process
    Deploy Processmodel      _hello_robot_framework.bpmn


*** Tasks ***
Check Exception on deploy
    [Tags]    RequirementsID=4612
    ${msg}=    Run Keyword And Expect Error    *    Deploy a process
    Log    ${msg}
    Should Contain    ${msg}    _hello_robot_framework.bpmn

Successfully deploy
    Deploy Processmodel    examples/hello_robot_framework.bpmn