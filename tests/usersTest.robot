*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           BuiltIn
Library           SeleniumLibrary
Library            XML


*** Variables ***
${BASE_URL}          http://localhost:8888
${EMAIL}       admin@gmail.com
${PASSWORD}    12345678

${USERNAME}    Robot
${USER_EMAIL}    robotuser@gmail.com
${USER_PASSWORD}    333222111

${USERNAME_UPDATE}    RobotUpdated
${USER_EMAIL_UPDATE}    robotuserUpdated@gmail.com


*** Keywords ***
Login
    Open Browser    ${BASE_URL}    chrome
    Maximize Browser Window


    Wait Until Element Is Visible    css=[itemid="emailInput"]    timeout=10s
    Click Element    css=[itemid="emailInput"]
    Element Should Be Enabled        css=[itemid="emailInput"]
    Input Text    css=[itemid="emailInput"]    ${EMAIL}

    Wait Until Element Is Visible    css=[itemid="passwordInput"]    timeout=10s
    Click Element    css=[itemid="passwordInput"]
    Element Should Be Enabled        css=[itemid="passwordInput"]
    Input Text    css=[itemid="passwordInput"]    ${PASSWORD}

    Click Element    css=[itemid="loginBtn"]
    Sleep    0.7

*** Test Cases ***
# Create

Teste de criação de usuário leitor
    Login
    Click Element    css=[itemid="Controle de usuários"]

    Wait Until Element Is Visible    css=[itemid="cadastrarBtn"]    timeout=10s
    Click Element    css=[itemid="cadastrarBtn"]    

    Wait Until Element Is Visible    css=[itemid="usernameInput"]    timeout=10s
    Input Text    css=[itemid="usernameInput"]    ${USERNAME}

    Input Text    css=[itemid="emailInput"]    ${USER_EMAIL}

    Input Text    css=[itemid="passwordInput"]    ${USER_PASSWORD}

    Click Element  css=[itemid="roleLeitor"]

    Click Element  css=[itemid="saveBtn"]

    Sleep    1

    Close Browser

Teste de criação de usuário editor
    Login
    Click Element    css=[itemid="Controle de usuários"]

    Wait Until Element Is Visible    css=[itemid="cadastrarBtn"]    timeout=10s
    Click Element    css=[itemid="cadastrarBtn"]    

    Wait Until Element Is Visible    css=[itemid="usernameInput"]    timeout=10s
    Input Text    css=[itemid="usernameInput"]    ${USERNAME}

    Input Text    css=[itemid="emailInput"]    ${USER_EMAIL}

    Input Text    css=[itemid="passwordInput"]    ${USER_PASSWORD}

    Click Element  css=[itemid="roleEditor"]

    Click Element  css=[itemid="saveBtn"]

    Sleep    1

    Close Browser

# Read
Teste de visualizar detalhes
    Login

    Click Element    css=[itemid="Controle de usuários"]

    Wait Until Element Is Visible    css=[itemid="visibility-7"]    timeout=3s
    Click Element    css=[itemid="visibility-7"]

    Sleep    3

    Click Element    css=[itemid="cancelBtn"]

    Sleep    0.5

    Close Browser

# Update
Teste de edição de usuário
    Login

    Click Element    css=[itemid="Controle de usuários"]

    Wait Until Element Is Visible    css=[itemid="edit-Robot"]    timeout=3s
    Click Element    css=[itemid="edit-Robot"]

    Sleep    1

    Click Element    css=[itemid="nameUpdateInput"]

    Press Keys       css=[itemid="nameUpdateInput"]    CTRL+A+BACKSPACE

    Input Text    css=[itemid="nameUpdateInput"]    ${USERNAME_UPDATE}

    Click Element    css=[itemid="emailUpdateInput"]

    Press Keys       css=[itemid="emailUpdateInput"]    CTRL+A+BACKSPACE

    Input Text    css=[itemid="emailUpdateInput"]    ${USER_EMAIL_UPDATE}

    Click Element    css=[itemid="saveBtn"]

    Sleep    0.5

    Close Browser

# Filter
Teste de filtro de usuários
    Login

    Click Element    css=[itemid="Controle de usuários"]

    Sleep    1

    Click Element    css=[itemid="filterBtn"]
    Sleep    0.5

    Click Element    css=[itemid="filterEditorBtn"]
    Sleep    2

    Click Element    css=[itemid="filterBtn"]
    Sleep    0.5

    Click Element    css=[itemid="filterLeitorBtn"]
    Sleep    2

    Click Element    css=[itemid="filterBtn"]
    Sleep    0.5

    Click Element    css=[itemid="filterTodosBtn"]
    Sleep    2

    Close Browser

Teste de pesquisa
    Login

    Click Element    css=[itemid="Controle de usuários"]

    Wait Until Element Is Visible    css=[itemid="searchInput"]

    Input Text    css=[itemid="searchInput"]    ${USERNAME_UPDATE}

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Sleep    1
    
    Close Browser
