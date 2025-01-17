*** Settings ***
Library           Collections
Library           BuiltIn
Library           SeleniumLibrary
Library           XML
Suite Setup    Iniciar Navegador
Suite Teardown    Fechar Navegador


*** Variables ***
${BROWSER}    firefox
${URL}        https://locadora-ryan.altislabtech.com.br/
${BASE_URL}          www.google.com
${EMAIL}       admin@gmail.com
${PASSWORD}    12345678
${HEADLESS_OPTIONS}    ${EMPTY}

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


    Wait Until Element Is Visible    css=[itemid="emailInput"]    timeout=1000s
    Click Element    css=[itemid="emailInput"]
    Element Should Be Enabled        css=[itemid="emailInput"]
    Input Text    css=[itemid="emailInput"]    ${EMAIL}

    Wait Until Element Is Visible    css=[itemid="passwordInput"]    timeout=1000s
    Click Element    css=[itemid="passwordInput"]
    Element Should Be Enabled        css=[itemid="passwordInput"]
    Input Text    css=[itemid="passwordInput"]    ${PASSWORD}

    Click Element    css=[itemid="loginBtn"]
    Sleep    2


*** Test Cases ***
Teste De Login Válido
    Login
    
    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

Teste de Logout
    Login
    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

    Sleep    2

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

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]
