*** Settings ***
Documentation   Template robot main suite.
Library         Collections

Library         AtlasEngineClient.py     http://localhost:56100    worker_id=my worker
#Library         AtlasEngineClient.py    self_hosted_engine = docker
#Library         AtlasEngineClient.py    self_hosted_engine = node

*** Variables ***
${CORRELATION}               -1
${USER_TASK_INSTANCE_ID}     -1
${EXTERNAL_TASK_ID}          -1

*** Tasks ***
Get engine info task
    ${INFO}                  Get Engine Info
    Log                      ${INFO}

*** Tasks ***
Deploy a process
    Deploy Process           hello_robot_framework.bpmn


*** Tasks ***
Start process with payload
    &{PAYLOAD}=              Create Dictionary                     foo=bar    hello=world
    ${PROCESS}=              Start Process                         hello_robot_framework    ${PAYLOAD}
    Set Suite Variable       ${CORRELATION}                        ${PROCESS.correlation_id}
    Should Be Equal          ${PROCESS.token_payload["hello"]}     world

*** Tasks ***
Get User Task by correlation_id
    Log                      ${CORRELATION}
    ${USER_TASK}             Get User Task By                      correlation_id=${CORRELATION}
    Log                      ${USER_TASK}
    Should Not Be Empty      ${USER_TASK.user_task_instance_id}
    Set Suite Variable       ${USER_TASK_INSTANCE_ID}              ${USER_TASK.user_task_instance_id}
    Should Be Equal          ${USER_TASK.process_model_id}         hello_robot_framework

*** Tasks ***
Finish User Task
    &{ANSWER}=               Create Dictionary                     field_01=The Value of field 1
    Log                      ${USER_TASK_INSTANCE_ID}
    Finish User Task         ${USER_TASK_INSTANCE_ID}              ${ANSWER}

*** Tasks ***
Get External Task
    ${TASK}                  Get External Task                     topic=doExternal
    Set Suite Variable       ${EXTERNAL_TASK_ID}                   ${TASK.id}

*** Tasks ***
Finish the external task
    &{ANSWER}=               Create Dictionary                     external_field_01=The Value of field 1
    Log                      ${EXTERNAL_TASK_ID}
    Finish External Task     ${EXTERNAL_TASK_ID}                   ${ANSWER}