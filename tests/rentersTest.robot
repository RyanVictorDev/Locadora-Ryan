*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           BuiltIn
Library           SeleniumLibrary
Library           XML
Library           DateTime


*** Variables ***
${BASE_URL}          http://localhost:8888
${EMAIL}       admin@gmail.com
${PASSWORD}    12345678

${RENTER_NAME}    Robot
${RENTER_EMAIL}    robotrenteremail@gmail.com
${RENTER_PHONE}    85982734654
${RENTER_ADRESS}    Rua Tal, Ali e acula
${RENTER_CPF}    00000000000

${RENTER_NAME_UPDATE}    RobotUpdated
${RENTER_EMAIL_UPDATE}    robotrenteremailupdated@gmail.com
${RENTER_PHONE_UPDATE}    85982734654
${RENTER_ADRESS_UPDATE }    Rua Tal, Ali e acula
${RENTER_CPF_UPDATE}    63191375090

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

Definir Data Atual
    ${TODAY}=    Get Current Date    result_format=%d/%m/%Y
    Set Suite Variable    ${TODAY}


*** Test Cases ***
# Create
Teste de criação de locatários
    Login
    Click Element    css=[itemid="Controle de locatários"]

    Wait Until Element Is Visible    css=[itemid="registerBtn"]
    Click Element    css=[itemid="registerBtn"]

    Click Element    css=[itemid="renterNameInput"]

    Input Text    css=[itemid="renterNameInput"]    ${RENTER_NAME}

    Input Text    css=[itemid="renterEmailInput"]    ${RENTER_EMAIL}

    Input Text    css=[itemid="renterPhoneInput"]    ${RENTER_PHONE}

    Input Text    css=[itemid="renterAdressInput"]    ${RENTER_ADRESS}

    Input Text    css=[itemid="renterCpfInput"]    ${RENTER_CPF}

    Click Element    css=[itemid="saveBtn"]

    Sleep    3
    
    Close Browser

# Read
Teste de visualizar detalhes do locatário
    Login
    Click Element    css=[itemid="Controle de locatários"]

    Wait Until Element Is Enabled    css=[itemid="visibility-Robot"]
    Click Element    css=[itemid="visibility-Robot"]

    Sleep    2

    Click Element    css=[itemid="closeBtn"]

    Close Browser

#Update
Teste de atualização de locatário
    Login
    Click Element    css=[itemid="Controle de locatários"]

    Wait Until Element Is Visible    css=[itemid="edit-Robot"]
    Click Element    css=[itemid="edit-Robot"]

    Wait Until Element Is Visible    css=[itemid="updateNameInput"]

    Press Keys       css=[itemid="updateNameInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateNameInput"]    ${RENTER_NAME_UPDATE}

    Press Keys       css=[itemid="updateEmailInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateEmailInput"]    ${RENTER_EMAIL_UPDATE}

    Press Keys       css=[itemid="updatePhoneInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updatePhoneInput"]    ${RENTER_PHONE_UPDATE}

    Press Keys       css=[itemid="updateAdressInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateAdressInput"]    ${RENTER_ADRESS_UPDATE }

    Press Keys       css=[itemid="updateCpfInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateCpfInput"]    ${RENTER_CPF_UPDATE}

    Click Element    css=[itemid="saveBtn"]

    Sleep    2

    Close Browser

# Delete
Teste de exclusão de locatário
    Login
    Click Element    css=[itemid="Controle de locatários"]

    Wait Until Element Is Visible    css=[itemid="delete-RobotUpdated"]
    Click Element    css=[itemid="delete-RobotUpdated"]

    Wait Until Element Is Visible    css=[itemid="saveBtn"]
    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Close Browser

Teste de exclusão de locatário com aluguel ativo
    Login
    Click Element    css=[itemid="Controle de aluguéis"]

    Wait Until Element Is Visible    css=[itemid="registerBtn"]
    Click Element    css=[itemid="registerBtn"]

    Input Text    css=[itemid="deliveryInput"]    30/11/2024    

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

    Click Element    css=[itemid="Controle de locatários"]


    Wait Until Element Is Visible    css=[itemid="delete-RobotUpdated"]
    Click Element    css=[itemid="delete-RobotUpdated"]

    Wait Until Element Is Visible    css=[itemid="saveBtn"]
    Click Element    css=[itemid="saveBtn"]
 
    Sleep    3

    Close Browser

Teste de pesquisa
    Login
    Click Element    css=[itemid="Controle de locatários"]

    Wait Until Element Is Visible    css=[itemid="searchInput"]

    Input Text    css=[itemid="searchInput"]    ${RENTER_NAME_UPDATE}

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Sleep    1
    
    Close Browser