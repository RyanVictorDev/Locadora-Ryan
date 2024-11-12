*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           BuiltIn

*** Variables ***
${BASE_URL}          http://localhost:9999/auth
${LOGIN_ENDPOINT}    /login
${VALID_EMAIL}       admin@gmail.com
${VALID_PASSWORD}    12345678

*** Test Cases ***
Teste De Login Válido
    [Documentation]    Testa o login com credenciais válidas.
    Create Session    mysession    ${BASE_URL}
    ${response}       POST On Session    mysession    ${LOGIN_ENDPOINT}    json={"email": "${VALID_EMAIL}", "password": "${VALID_PASSWORD}"}
    Should Be Equal As Strings    ${response.status_code}    200

    # Extrai o JSON da resposta usando o próprio RequestsLibrary
    ${response_json}=    Evaluate    ${response.json()}    json
    ${token}=    Get From Dictionary    ${response_json}    token
    ${role}=    Get From Dictionary    ${response_json}    role

    # Valida se o token e role estão presentes
    Should Not Be Empty    ${token}
    Should Not Be Empty    ${role}
    Log    Login bem-sucedido com token e role válidos



# Teste para criação de usuário
# Validar Criação de Usuário
#     [Documentation]    Testa o endpoint de criação de um novo usuário.
#     Create Session    springboot    ${BASE_URL}
#     ${data}=    Create Dictionary    name=John Doe    email=johndoe@example.com
#     ${response}=    POST    springboot    /api/users    json=${data}
#     Should Be Equal As Strings    ${response.status_code}    201
#     Log    Usuário criado: ${response.json()}

# Teste para consulta de usuário por ID
# Consultar Usuário por ID
#     [Documentation]    Testa o endpoint de consulta de usuário.
#     ${user_id}=    Set Variable    1
#     ${response}=    GET    springboot    /api/users/${user_id}
#     Should Be Equal As Strings    ${response.status_code}    200
#     Log    Dados do usuário: ${response.json()}

# Teste para atualização de usuário
# Atualizar Usuário
#     [Documentation]    Testa o endpoint de atualização de usuário.
#     ${user_id}=    Set Variable    1
#     ${data}=    Create Dictionary    name=John Updated    email=johndoe_updated@example.com
#     ${response}=    PUT    springboot    /api/users/${user_id}    json=${data}
#     Should Be Equal As Strings    ${response.status_code}    200
#     Log    Usuário atualizado: ${response.json()}

# Teste para exclusão de usuário
# Excluir Usuário
#     [Documentation]    Testa o endpoint de exclusão de usuário.
#     ${user_id}=    Set Variable    1
#     ${response}=    DELETE    springboot    /api/users/${user_id}
#     Should Be Equal As Strings    ${response.status_code}    204
#     Log    Usuário excluído com sucesso.
