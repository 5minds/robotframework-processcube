*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False

*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}

*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_minimal.bpmn
