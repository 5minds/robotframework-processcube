*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False
${CORRELATION}               -1


*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
Library         Collections
Library         DateTime


*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_minimal.bpmn

Start process model
    ${date} =	Get Current Date
    ${convert_date}=      Convert Date      ${date}      result_format=%Y_%m_%d_%H_%M_%S
    Set Suite Variable       ${CORRELATION}    check_processinstance_${convert_date}

    &{PAYLOAD}=              Create Dictionary     foo=bar    hello=world

    ${PROCESS_INSTANCE}=     Start Processmodel    hello_minimal    ${PAYLOAD}    correlation_id=${CORRELATION}
    
    Set Suite Variable       ${CORRELATION}        ${PROCESS_INSTANCE.correlation_id}
    Log                      ${CORRELATION}

Get the process instance by correlation
    ${RESULT}                Get Processinstances By Correlation            ${CORRELATION}

    Log                      ${RESULT}

    ${cnt}=    Get length    ${RESULT}
    Log    ${cnt}
    

Get the process instance by process model
    ${RESULT}                Get Processinstances By Processmodel          hello_minimal

    Log                      ${RESULT}

    ${cnt}=    Get length    ${RESULT}
    Log    ${cnt}
