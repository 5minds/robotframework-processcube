*** Settings ***
Documentation   Template robot main suite.
Resource        keywords.robot
Library         Library.py
Library         AtlasEngineClient.py    http://localhost:56100
Library    Process
Library    Collections
Variables       variables.py


*** Tasks ***
Example task
    Example Keyword
    Example Python Keyword

*** Tasks ***
Get engine info task
    ${INFO}    Get Engine Info
    Log    ${INFO}

*** Tasks ***
Start process
    ${RESULT}    Start Processmodel     hello_world
    Log    ${RESULT}

