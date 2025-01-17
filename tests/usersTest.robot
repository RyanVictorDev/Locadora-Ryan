*** Settings ***
Library           Collections
Library           BuiltIn
Library           SeleniumLibrary
Library           XML
Library           DateTime
Suite Setup    Iniciar Navegador
Suite Teardown    Fechar Navegador

*** Variables ***
${BROWSER}    firefox
${URL}        https://locadora-ryan.altislabtech.com.br/
${HEADLESS_OPTIONS}    ${EMPTY}

${BASE_URL}          http://localhost:7171
${EMAIL}       admin@gmail.com
${PASSWORD}    12345678

${USERNAME}    Robot
${USER_EMAIL}    robotusertestenew@gmail.com
${USER_PASSWORD}    333222111

${USERNAME_EDITOR}    Robot Editor Test
${USER_EMAIL_EDITOR}    roboteditortestenew@gmail.com

${USERNAME_UPDATE}    RobotUpdatedAgain
${USER_EMAIL_UPDATE}    robotuserUpdatedagain@gmail.com
${ROLE_EDITOR}    Editor
${ROLE_LEITOR}    Leitor

${USERNAME_UPDATE_TWO}    RobotUpdated Two
${USER_EMAIL_UPDATE_TWO}    robotusertwon@gmail.com


*** Keywords ***
Iniciar Navegador
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Set Selenium Speed    3s

Fechar Navegador
    Close Browser

Create Chrome Options
    ${options}=    Evaluate    sys.modules['selenium.webdriver.chrome.options'].Options()    sys, selenium.webdriver.chrome.options
    Call Method    ${options}    add_argument    --headless
    RETURN    ${options}

Login
    Iniciar Navegador
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
    Sleep    1

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

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

Teste de criação de usuário editor
    Login
    Click Element    css=[itemid="Controle de usuários"]

    Wait Until Element Is Visible    css=[itemid="cadastrarBtn"]    timeout=10s
    Click Element    css=[itemid="cadastrarBtn"]    

    Wait Until Element Is Visible    css=[itemid="usernameInput"]    timeout=10s
    Input Text    css=[itemid="usernameInput"]    ${USERNAME_EDITOR}

    Input Text    css=[itemid="emailInput"]    ${USER_EMAIL_EDITOR}

    Input Text    css=[itemid="passwordInput"]    ${USER_PASSWORD}

    Click Element  css=[itemid="roleEditor"]

    Click Element  css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

# Read
Teste de visualizar detalhes
    Login

    Click Element    css=[itemid="Controle de usuários"]

    Wait Until Element Is Visible    css=[itemid="visibility-Robot"]    timeout=3s
    Click Element    css=[itemid="visibility-Robot"]

    Sleep    3

    Click Element    css=[itemid="cancelBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

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

    Click Element    css=[itemid="Controle de usuários"]

    Wait Until Element Is Visible    css=[itemid="edit-Robot Editor Test"]    timeout=3s
    Click Element    css=[itemid="edit-Robot Editor Test"]

    Sleep    1

    Click Element    css=[itemid="nameUpdateInput"]

    Press Keys       css=[itemid="nameUpdateInput"]    CTRL+A+BACKSPACE

    Input Text    css=[itemid="nameUpdateInput"]    ${USERNAME_UPDATE_TWO}

    Click Element    css=[itemid="emailUpdateInput"]

    Press Keys       css=[itemid="emailUpdateInput"]    CTRL+A+BACKSPACE

    Input Text    css=[itemid="emailUpdateInput"]    ${USER_EMAIL_UPDATE_TWO}

    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

Teste de pesquisa
    Login

    Click Element    css=[itemid="Controle de usuários"]

    Wait Until Element Is Visible    css=[itemid="searchInput"]

    Input Text    css=[itemid="searchInput"]    ${USERNAME_UPDATE}

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Input Text    css=[itemid="searchInput"]    ${ROLE_EDITOR}

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Input Text    css=[itemid="searchInput"]    ${ROLE_LEITOR}

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]
    