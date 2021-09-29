*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False
${CORRELATION}               -1


*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
Library         Collections


*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_empty_task.bpmn

Start process model
    &{PAYLOAD}=              Create Dictionary     foo=bar    hello=world
    ${PROCESS_INSTANCE}=     Start Processmodel    hello_empty_task    ${PAYLOAD}
    Set Suite Variable       ${CORRELATION}        ${PROCESS_INSTANCE.correlation_id}
    Log                      ${CORRELATION}

Handle empty task by correlation_id
    Log                      ${CORRELATION}
    ${EMPTY_TASK}            Get Empty Task By                     correlation_id=${CORRELATION}
    Log                      ${EMPTY_TASK.empty_task_instance_id}
    Finish Empty Task        ${EMPTY_TASK.empty_task_instance_id}


Get the process instance
    ${RESULT}                Get Processinstance Result            correlation_id=${CORRELATION}
    Log                      ${RESULT}
    