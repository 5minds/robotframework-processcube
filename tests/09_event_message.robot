*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False
${CORRELATION}               -1


*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
Library         Collections


*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_message.bpmn

Start process model
    &{PAYLOAD}=              Create Dictionary     foo=bar    hello=world
    ${PROCESS_INSTANCE}=     Start Processmodel    hello_message    ${PAYLOAD}
    Set Suite Variable       ${CORRELATION}        ${PROCESS_INSTANCE.correlation_id}
    Log                      ${CORRELATION}

Send Message
    &{PAYLOAD}=              Create Dictionary        message_field1=Value field 1    message_field2=Value field 2
    Send Message             catch_message            ${PAYLOAD}                      delay=0.5


Get the process instance
    ${RESULT}                Get Processinstance Result            correlation_id=${CORRELATION}
    Log                      ${RESULT}
    