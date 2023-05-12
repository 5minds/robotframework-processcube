*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False
${CORRELATION}               -1


*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
Library         Collections
Library         DateTime


*** Tasks ***
Successfully deploy
    #Deploy Processmodel    processes/hello_minimal.bpmn
    Deploy Processmodel    processes/hello_check_processinstance.bpmn

Start process model
    ${date} =	Get Current Date
    ${convert_date}=      Convert Date      ${date}      result_format=%Y_%m_%d_%H_%M_%S
    Set Suite Variable       ${CORRELATION}    check_processinstance_${convert_date}

    &{PAYLOAD}=              Create Dictionary     foo=bar    hello=world

    ${PROCESS_INSTANCE}=     Start Processmodel    hello_check_processinstance    ${PAYLOAD}    correlation_id=${CORRELATION}
    
    Set Suite Variable       ${CORRELATION}        ${PROCESS_INSTANCE.correlation_id}
    Log                      ${CORRELATION}

Get the process instance by correlation
    ${RESULT}                Get Active Processinstances By Correlation            ${CORRELATION}

    Log                      ${RESULT}

    ${cnt}=    Get length    ${RESULT}
    Log    ${cnt}
    

Get the process instance by process model
    ${RESULT}                Get Active Processinstances By Processmodel          hello_check_processinstance

    Log                      ${RESULT}

    ${cnt}=    Get length    ${RESULT}
    Log    ${cnt}
