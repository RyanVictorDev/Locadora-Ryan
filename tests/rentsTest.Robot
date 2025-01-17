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

${BOOK_NAME}    Livro Testes Robot
${BOOK_AUTHOR}    Robot
${BOOK_QUANTITY}    123
${BOOK_LAUNCH_DATE}    15/11/2024

${BOOK_NAME_UPDATED}    Livro Testes Robot Updated
${BOOK_AUTHOR_UPDATED}    Robot Updated

${DEADLINE}    30/01/2025


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

*** Test Cases ***
# Create
Teste de aluguél de livros
    Login
    Click Element    css=[itemid="Controle de aluguéis"]

    Wait Until Element Is Visible    css=[itemid="registerBtn"]
    Click Element    css=[itemid="registerBtn"]

    Wait Until Element Is Visible    css=[itemid="deliveryInput"]
    Input Text    css=[itemid="deliveryInput"]    30/12/2024    

    Wait Until Page Contains Element    xpath=//*[@itemid='renterInput']
    Wait Until Element Is Visible    xpath=//*[@itemid='renterInput']    timeout=5s
    Click Element    xpath=//*[@itemid='renterInput']    

    Wait Until Page Contains Element    //div[@role="option" and .//span[text()="Robot"]]    timeout=10s    
    Click Element    //div[@role="option" and .//span[text()="Robot"]] 

    Wait Until Page Contains Element    xpath=//*[@itemid='bookInput']
    Wait Until Element Is Visible    xpath=//*[@itemid='bookInput']    timeout=5s

    Sleep    2

    Wait Until Page Contains Element    xpath=//*[@itemid='bookInput']
    Wait Until Element Is Visible    xpath=//*[@itemid='bookInput']    timeout=5s

    Click Element    xpath=//*[@itemid='bookInput']    

    Sleep    2s

    Wait Until Page Contains Element    //div[@role="option" and .//span[text()="Livro Novo"]]    timeout=10s    
    Click Element    //div[@role="option" and .//span[text()="Livro Novo"]] 

    Click Element    css=[itemid="saveBtn"]

    Sleep    2

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

# Update
Teste de atualizacao de aluguel de livro
    Login
    Click Element    css=[itemid="Controle de aluguéis"]

    Wait Until Element Is Visible    css=[itemid="edit-undefined"]
    Click Element    css=[itemid="edit-undefined"]

    Press Keys    css=[itemid="deadLineInputUpdate"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="deadLineInputUpdate"]    ${DEADLINE}

    Wait Until Page Contains Element    xpath=//*[@itemid='renterInputUpdate']
    Wait Until Element Is Visible    xpath=//*[@itemid='renterInputUpdate']    timeout=5s

    Press Keys    xpath=//*[@itemid='renterInputUpdate']    CTRL+A+BACKSPACE

    Click Element    xpath=//*[@itemid='renterInputUpdate']    

    Sleep    2s

    Wait Until Page Contains Element    //div[@role="option" and .//span[text()="Regina Caze"]]    timeout=10s    
    Click Element    //div[@role="option" and .//span[text()="Regina Caze"]] 

    Sleep    2s

    Wait Until Page Contains Element    xpath=//*[@itemid='bookInputUpdate']
    Wait Until Element Is Visible    xpath=//*[@itemid='bookInputUpdate']    timeout=5s

    Press Keys    xpath=//*[@itemid='bookInputUpdate']    CTRL+A+BACKSPACE

    Click Element    xpath=//*[@itemid='bookInputUpdate']    

    Wait Until Page Contains Element    //div[@role="option" and .//span[text()="Livro Original"]]    timeout=10s    
    Click Element    //div[@role="option" and .//span[text()="Livro Original"]] 
    
    Click Element    css=[itemid="saveBtn"]

    Sleep    2

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

Teste de devolução de livro
    Login
    Click Element    css=[itemid="Controle de aluguéis"]

    Wait Until Element Is Visible    css=[itemid="bookmark_border-undefined"]
    Click Element    css=[itemid="bookmark_border-undefined"]

    Wait Until Element Is Visible    css=[itemid="saveBtn"]
    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

# Filter
Teste de filtro de alugueis
    Login
    Click Element    css=[itemid="Controle de aluguéis"]

    Sleep    1

    Click Element    css=[itemid="filterBtn"]
    Sleep    0.5

    Click Element    css=[itemid="filterAlugadosBtn"]
    Sleep    2

    Click Element    css=[itemid="filterBtn"]
    Sleep    0.5

    Click Element    css=[itemid="filterAtrasadosBtn"]
    Sleep    2

    Click Element    css=[itemid="filterBtn"]
    Sleep    0.5

    Click Element    css=[itemid="filterNoPrazoBtn"]
    Sleep    2

    Click Element    css=[itemid="filterBtn"]
    Sleep    0.5

    Click Element    css=[itemid="filterForaDoPrazoBtn"]
    Sleep    2

    Click Element    css=[itemid="filterBtn"]
    Sleep    0.5

    Click Element    css=[itemid="filterTodosBtn"]
    Sleep    2

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

Teste de pesquisa
    Login
    Click Element    css=[itemid="Controle de aluguéis"]

    Wait Until Element Is Visible    css=[itemid="searchInput"]

    Input Text    css=[itemid="searchInput"]    RobotUpdated

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Input Text    css=[itemid="searchInput"]    Atrasado

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Input Text    css=[itemid="searchInput"]    Alugado

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Input Text    css=[itemid="searchInput"]    Devolvido

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Sleep    1

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]
    