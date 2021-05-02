*** Variables ***
${CORRELATION}               -1
${USER_TASK_INSTANCE_ID}     -1
${EXTERNAL_TASK_ID}          -1
&{DOCKER_OPTIONS}            auto_remove=False

*** Settings ***
Documentation   Template robot main suite.
Library         Collections

#Library         ProcessCubeLibrary     engine_url=http://localhost:56100    worker_id=my worker
Library          ProcessCubeLibrary    self_hosted_engine=docker    worker_id=my worker    docker_options=${DOCKER_OPTIONS}
#Suite Teardown   Engine Shutdown 

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

    &{ANSWER}=               Create Dictionary                     field_01=not_handle_task

    Finish User Task         ${USER_TASK.user_task_instance_id}    ${ANSWER}

*** Tasks ***
Send Message
    &{PAYLOAD}=              Create Dictionary                     message_field1=Value field 1    message_field2=Value field 2
    Send Message             CatchMessage                          ${PAYLOAD}                      delay=0.5

*** Tasks ***
Send Signal
    Send Signal              CatchSignal                           delay=0.2     

*** Tasks ***
Get Process Instance
    ${RESULT}                Get Processinstance                  correlation_id=${CORRELATION}
    Log                      ${RESULT}
