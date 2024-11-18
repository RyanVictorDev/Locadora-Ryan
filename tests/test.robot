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
    Sleep    2


*** Test Cases ***
Teste De Login Válido
    Login

    Close Browser

Teste de Logout
    Login
    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=10s
    Click Element    css=[itemid="logoutBtn"]

    Sleep    2

    Close Browser

Teste de sidebar
    Login
    Click Element    css=[itemid="Controle de usuários"]
    Sleep    1

    Click Element    css=[itemid="Controle de locatários"]
    Sleep    1

    Click Element    css=[itemid="Controle de editoras"]
    Sleep    1

    Click Element    css=[itemid="Controle de livros"]
    Sleep    1

    Click Element    css=[itemid="Controle de aluguéis"]
    Sleep    1

    Click Element    css=[itemid="Relatório geral"]
    Sleep    1

    Close Browser