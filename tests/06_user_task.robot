*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False
${CORRELATION}               -1


*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
Library         Collections


*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_user_task.bpmn

Start process model
    &{PAYLOAD}=              Create Dictionary     foo=bar    hello=world
    ${PROCESS_INSTANCE}=     Start Processmodel    hello_user_task    ${PAYLOAD}
    Set Suite Variable       ${CORRELATION}        ${PROCESS_INSTANCE.correlation_id}
    Log                      ${CORRELATION}

Handle User Task by correlation_id
    Log                      ${CORRELATION}
    ${USER_TASK}             Get User Task By                      correlation_id=${CORRELATION}
    Log                      ${USER_TASK}
    Should Not Be Empty      ${USER_TASK.user_task_instance_id}
    Should Be Equal          ${USER_TASK.process_model_id}         hello_user_task

    &{ANSWER}=               Create Dictionary                     field_01=from user task    
    Finish User Task         ${USER_TASK.user_task_instance_id}    ${ANSWER}


Get the process instance
    ${RESULT}                Get Processinstance Result            correlation_id=${CORRELATION}
    Log                      ${RESULT}
    