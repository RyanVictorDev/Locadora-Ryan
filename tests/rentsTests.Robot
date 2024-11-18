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

${BOOK_NAME}    Livro Testes Robot
${BOOK_AUTHOR}    Robot
${BOOK_QUANTITY}    123
${BOOK_LAUNCH_DATE}    15/11/2024

${BOOK_NAME_UPDATED}    Livro Testes Robot Updated
${BOOK_AUTHOR_UPDATED}    Robot Updated

${DEADLINE}    30/11/2024


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
Teste de aluguél de livros
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

# Update
Teste de aluguel de livro
    Login
    Click Element    css=[itemid="Controle de aluguéis"]

    Wait Until Element Is Visible    css=[itemid="edit-undefined"]
    Click Element    css=[itemid="edit-undefined"]

    Press Keys    css=[itemid="deadLineInputUpdate"]    CTRL+A+BACKSPACE
    Input Text    css=[itemid="deadLineInputUpdate"]    ${DEADLINE}
    
    Click Element    css=[itemid="saveBtn"]

    Sleep    2

    Close Browser

Teste de devolução de livro
    Login
    Click Element    css=[itemid="Controle de aluguéis"]

    Wait Until Element Is Visible    css=[itemid="bookmark_border-undefined"]
    Click Element    css=[itemid="bookmark_border-undefined"]

    Click Element    css=[itemid="saveBtn"]

    Sleep    3

    Close Browser

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

    Close Browser

Teste de pesquisa
    Login
    Click Element    css=[itemid="Controle de aluguéis"]

    Wait Until Element Is Visible    css=[itemid="searchInput"]

    Input Text    css=[itemid="searchInput"]    RobotUpdated

    Click Element    css=[itemid="searchBtn"]

    Sleep    2

    Click Element    css=[itemid="closeSearchBtn"]

    Sleep    1
    
    Close Browser