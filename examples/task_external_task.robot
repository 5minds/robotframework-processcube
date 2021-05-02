*** Variables ***
${CORRELATION}               -1
${USER_TASK_INSTANCE_ID}     -1
${EXTERNAL_TASK_ID}          -1

*** Settings ***
Documentation   Template robot main suite.
Library         Collections

Library         ProcessCubeLibrary    engine_url=http://localhost:56100    worker_id=my worker

*** Tasks ***
Get engine info task
    ${INFO}                  Get Engine Info
    Log                      ${INFO}

*** Tasks ***
Deploy a process
    Deploy Processmodel      hello_robot_framework.bpmn


*** Tasks ***
Start process with payload
    &{PAYLOAD}=              Create Dictionary                     foo=bar    hello=world
    ${PROCESS}=              Start Processmodel                    hello_robot_framework    ${PAYLOAD}
    Set Suite Variable       ${CORRELATION}                        ${PROCESS.correlation_id}

*** Tasks ***
Handle User Task by correlation_id
    Log                      ${CORRELATION}
    ${USER_TASK}             Get User Task By                      correlation_id=${CORRELATION}
    Log                      ${USER_TASK}
    Should Not Be Empty      ${USER_TASK.user_task_instance_id}
    Should Be Equal          ${USER_TASK.process_model_id}         hello_robot_framework

    &{ANSWER}=               Create Dictionary                     field_01=handle_task
    
    Finish User Task         ${USER_TASK.user_task_instance_id}    ${ANSWER}

*** Tasks ***
Handle External Task
    ${TASK}                  Get External Task                     topic=doExternal
    &{ANSWER}=               Create Dictionary                     external_field_01=The Value of field 1
    Log                      ${TASK.id}
    Finish External Task     ${TASK.id}                            ${ANSWER}

*** Tasks ***
Get Processinstance Result
    ${RESULT}                Get Processinstance Result            correlation_id=${CORRELATION}
    Log                      ${RESULT}
    Should Not Be Empty      ${RESULT['external_field_01']}
