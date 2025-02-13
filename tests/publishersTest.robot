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

${PUBLISHER_NAME}    Robot
${PUBLISHER_EMAIL}    robotpublisheremail@gmail.com
${PUBLISHER_PHONE}    85982734654
${PUBLISHER_SITE}    https://robot.com

${PUBLISHER_NAME_UPDATED}    RobotUpdated
${PUBLISHER_EMAIL_UPDATED}    robotpublisheremailupdated@gmail.com
${PUBLISHER_PHONE_UPDATED}    85982734655
${PUBLISHER_SITE_UPDATED}    https://roboot.com

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

Definir Data Atual
    ${TODAY}=    Get Current Date    result_format=%d/%m/%Y
    Set Suite Variable    ${TODAY}


*** Test Cases ***
# Create
Teste de criação de editoras
    Login
    Click Element    css=[itemid="Controle de editoras"]

    Wait Until Element Is Visible    css=[itemid="registerBtn"]
    Click Element    css=[itemid="registerBtn"]

    Wait Until Element Is Visible    css=[itemid="publisherNameInput"]
    Click Element    css=[itemid="publisherNameInput"]

    Input Text    css=[itemid="publisherNameInput"]    ${PUBLISHER_NAME}

    Input Text    css=[itemid="publisherEmailInput"]    ${PUBLISHER_EMAIL}

    Input Text    css=[itemid="publisherPhoneInput"]    ${PUBLISHER_PHONE}

    Input Text    css=[itemid="publisherSiteInput"]    ${PUBLISHER_SITE}

    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]
    
# Read
Teste de visualizar detalhes da editora
    Login
    Click Element    css=[itemid="Controle de editoras"]

    Click Element    css=[itemid="visibility-Robot"]

    Sleep    2

    Click Element    css=[itemid="closeBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

#Update
Teste de atualização da editora
    Login
    Click Element    css=[itemid="Controle de editoras"]

    Wait Until Element Is Visible    css=[itemid="edit-Robot"]
    Click Element    css=[itemid="edit-Robot"]

    Wait Until Element Is Visible    css=[itemid="updateNameInput"]

    Press Keys       css=[itemid="updateNameInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateNameInput"]    ${PUBLISHER_NAME_UPDATED}

    Press Keys       css=[itemid="updateEmailInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateEmailInput"]    ${PUBLISHER_EMAIL_UPDATED}

    Press Keys       css=[itemid="updatePhoneInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updatePhoneInput"]    ${PUBLISHER_PHONE_UPDATED}

    Press Keys       css=[itemid="updateSiteInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateSiteInput"]    ${PUBLISHER_SITE_UPDATED}

    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

# Delete
Teste de exclusão de editora
    Login
    Click Element    css=[itemid="Controle de editoras"]

    Wait Until Element Is Visible    css=[itemid="delete-RobotUpdated"]
    Click Element    css=[itemid="delete-RobotUpdated"]

    Wait Until Element Is Visible    css=[itemid="saveBtn"]
    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

Teste de exclusão de editora com aluguel ativo
    Login
    Click Element    css=[itemid="Controle de aluguéis"]

    Wait Until Element Is Visible    css=[itemid="registerBtn"]
    Click Element    css=[itemid="registerBtn"]

    Input Text    css=[itemid="deliveryInput"]    30/01/2025 

    Wait Until Page Contains Element    xpath=//*[@itemid='renterInput']
    Wait Until Element Is Visible    xpath=//*[@itemid='renterInput']    timeout=5s
    Click Element    xpath=//*[@itemid='renterInput']    

    Wait Until Page Contains Element    //div[@role="option" and .//span[text()="RobotUpdated"]]    timeout=10s    
    Click Element    //div[@role="option" and .//span[text()="RobotUpdated"]] 

    Wait Until Page Contains Element    xpath=//*[@itemid='bookInput']
    Wait Until Element Is Visible    xpath=//*[@itemid='bookInput']    timeout=5s
    Click Element    xpath=//*[@itemid='bookInput']    

    Wait Until Page Contains Element    //div[@role="option" and .//span[text()="Livro Testes Robot"]]    timeout=10s    
    Click Element    //div[@role="option" and .//span[text()="Livro Testes Robot"]] 

    Click Element    css=[itemid="saveBtn"]

    Sleep    2

    Click Element    css=[itemid="Controle de editoras"]
    
    Wait Until Element Is Visible    css=[itemid="delete-RobotUpdated"]
    Click Element    css=[itemid="delete-RobotUpdated"]

    Wait Until Element Is Visible    css=[itemid="saveBtn"]
    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

Teste de pesquisa
    Login
    Click Element    css=[itemid="Controle de editoras"]

    Wait Until Element Is Visible    css=[itemid="searchInput"]

    Input Text    css=[itemid="searchInput"]    ${PUBLISHER_NAME_UPDATED}

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Sleep    1

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]
    