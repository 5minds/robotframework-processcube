*** Settings ***
Library         ProcessCubeLibrary     engine_url=http://localhost:56000

*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_minimal.bpmn
