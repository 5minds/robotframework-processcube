*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False
${CORRELATION}               -1


*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
Library         Collections


*** Tasks ***
Successfully deploy
    #Deploy Processmodel    processes/hello_minimal.bpmn
    Deploy Processmodel    processes/hello_delayed_result.bpmn

Start process model
    &{PAYLOAD}=              Create Dictionary     foo=bar    hello=world
    #${PROCESS_INSTANCE}=     Start Processmodel    hello_minimal    ${PAYLOAD}
    ${PROCESS_INSTANCE}=     Start Processmodel    hello_delayed_result    ${PAYLOAD}
    Set Suite Variable       ${CORRELATION}        ${PROCESS_INSTANCE.correlation_id}
    Log                      ${CORRELATION}

Get the process instance
    Sleep    2s    # Wartet 2 Sekunden
    ${RESULT}                Get Processinstance Result            correlation_id=${CORRELATION}  max_retries=10    delay=1    backoff_factor=1
    Log                      ${RESULT}
    &{EQ_RESULT}=              Create Dictionary     foo=bar    hello=world
    Should Be Equal          ${RESULT}    ${EQ_RESULT}
    