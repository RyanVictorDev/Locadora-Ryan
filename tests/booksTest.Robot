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

${DEADLINE}    30/12/2024


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
Teste de criação de livros
    Login
    Click Element    css=[itemid="Controle de livros"]

    Wait Until Element Is Visible    css=[itemid="registerBtn"]
    Click Element    css=[itemid="registerBtn"]

    Wait Until Element Is Enabled    css=[itemid="bookNameInput"]

    Click Element    css=[itemid="bookNameInput"]

    Input Text    css=[itemid="bookNameInput"]    ${BOOK_NAME}

    Input Text    css=[itemid="bookAuthInput"]    ${BOOK_AUTHOR}

    Input Text    css=[itemid="bookQuantityInput"]    ${BOOK_QUANTITY}

    Input Text    css=[itemid="bookLaunchDateInput"]    ${BOOK_LAUNCH_DATE}
    
    Wait Until Page Contains Element    xpath=//*[@itemid='publisherInput']
    Wait Until Element Is Visible    xpath=//*[@itemid='publisherInput']    timeout=5s
    Click Element    xpath=//*[@itemid='publisherInput']    

    Wait Until Page Contains Element    //div[@role="option" and .//span[text()="RobotUpdated"]]    timeout=10s    
    Click Element    //div[@role="option" and .//span[text()="RobotUpdated"]] 

    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]
    
Teste de aluguél de livro
    Login
    Click Element    css=[itemid="Controle de livros"]

    Wait Until Element Is Visible    css=[itemid="bookmark-Livro Testes Robot"]
    Click Element    css=[itemid="bookmark-Livro Testes Robot"]

    Wait Until Element Is Visible    css=[itemid="deadLineInput"]
    Input Text    css=[itemid="deadLineInput"]    ${DEADLINE}

    Wait Until Page Contains Element    xpath=//*[@itemid='renterInput']
    Wait Until Element Is Visible    xpath=//*[@itemid='renterInput']    timeout=5s
    Click Element    xpath=//*[@itemid='renterInput']    

    Wait Until Page Contains Element    //div[@role="option" and .//span[text()="RobotUpdated"]]    timeout=10s    
    Click Element    //div[@role="option" and .//span[text()="RobotUpdated"]] 

    Click Element    css=[itemid="saveBtn"]

    Sleep    10

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

# Update
Teste de edição de livros
    Login
    Click Element    css=[itemid="Controle de livros"]

    Wait Until Element Is Visible    css=[itemid="edit-Livro Testes Robot"]
    Click Element    css=[itemid="edit-Livro Testes Robot"]

    Wait Until Element Is Enabled    css=[itemid="updateNameInput"]

    Click Element    css=[itemid="updateNameInput"]

    Press Keys    css=[itemid="updateNameInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateNameInput"]    ${BOOK_NAME_UPDATED}

    Press Keys    css=[itemid="updateAuthInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateAuthInput"]    ${BOOK_AUTHOR_UPDATED}

    Press Keys    css=[itemid="updateQuantityInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateQuantityInput"]    ${BOOK_QUANTITY}

    Press Keys    css=[itemid="updateLaunchDateInput"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="updateLaunchDateInput"]    ${BOOK_LAUNCH_DATE}
    
    # Wait Until Page Contains Element    xpath=//*[@itemid='publisherInput']
    # Wait Until Element Is Visible    xpath=//*[@itemid='publisherInput']    timeout=5s
    # Click Element    xpath=//*[@itemid='publisherInput']    

    # Wait Until Page Contains Element    //div[@role="option" and .//span[text()="RobotUpdated"]]    timeout=10s    
    # Click Element    //div[@role="option" and .//span[text()="RobotUpdated"]] 

    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]
    
# Delete
Teste de exclusão de livros
    Login
    Click Element    css=[itemid="Controle de livros"]

    Wait Until Element Is Visible    css=[itemid="delete-Livro Testes Robot Updated"]
    Click Element    css=[itemid="delete-Livro Testes Robot Updated"]

    Wait Until Element Is Visible    css=[itemid="saveBtn"]
    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

Teste de exclusão de livros alugados
    Login
    Click Element    css=[itemid="Controle de livros"]

    Wait Until Element Is Visible    css=[itemid="delete-Livro Testes Robot"]
    Click Element    css=[itemid="delete-Livro Testes Robot"]

    Wait Until Element Is Visible    css=[itemid="saveBtn"]
    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]

Teste de pesquisa
    Login
    Click Element    css=[itemid="Controle de livros"]

    Wait Until Element Is Visible    css=[itemid="searchInput"]

    Input Text    css=[itemid="searchInput"]    ${BOOK_NAME}

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Sleep    1
    
    Wait Until Element Is Visible    css=[itemid="logoutBtn"]    timeout=1000s
    Click Element    css=[itemid="logoutBtn"]