*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False

*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}    max_retries=100

*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_minimal.bpmn

Start process model
    Start Processmodel     hello_minimal    payload={}
