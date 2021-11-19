*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False

*** Settings ***
Library         ProcessCubeLibrary    self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}    WITH NAME    Engine01
Library         ProcessCubeLibrary    self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}    WITH NAME    Engine02

*** Tasks ***
Engine info from Engine01
    ${INFO}=    Engine01.Get Engine Info
    Log    ${INFO}


Engine info from Engine02
    ${INFO}=    Engine02.Get Engine Info
    Log    ${INFO}
