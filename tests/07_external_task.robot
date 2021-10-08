*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False
${CORRELATION}               -1


*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
Library         Collections


*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_external_task.bpmn

Start process model
    &{PAYLOAD}=              Create Dictionary     foo=bar    hello=world
    ${PROCESS_INSTANCE}=     Start Processmodel    hello_external_task    ${PAYLOAD}
    Set Suite Variable       ${CORRELATION}        ${PROCESS_INSTANCE.correlation_id}
    Log                      ${CORRELATION}

Handle External Task
    ${TASK}                  Get External Task                     topic=doExternal
    &{ANSWER}=               Create Dictionary                     external_field_01=The Value of field 1
    Log                      ${TASK.id}
    Finish External Task     ${TASK.id}                            ${ANSWER}


Get the process instance
    ${RESULT}                Get Processinstance Result            correlation_id=${CORRELATION}
    Log                      ${RESULT}
    