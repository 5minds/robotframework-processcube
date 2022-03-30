*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False

*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}    max_retries=100

*** Tasks ***
Deploy minimal
    Log Start Parameters
    Deploy Processmodel    processes/hello_minimal.bpmn
