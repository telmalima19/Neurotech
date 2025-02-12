*** Settings ***


Library    RequestsLibrary
Library    JSONLibrary

*** Variables ***
${BASE_URL}    https://viacep.com.br/ws
${INVALIDO_CEP_MENOR}    /111/json/  #CEP menos de 8 digitos
${INVALIDO_CEP_MAIOR}    /222222222/json/  #CEP mais de 8 digitos
${VAZIO_CEP}    //json/
${VALIDO_CEP}    /53230200/json/
${DIFERENTE_CEP}    /53230115/json/
${VALIDO_CEP_TRACO}    /53230-200/json/
${INVALIDO_CEP}    /11111111/json/
${STATUS_ESPERADO}    400
${STATUS_404}    404
${VAZIO}    Set Variable    ""
${CEP_ESPERADO}    Set Variable    53230200
${CEP_RECEBIDO}    Set Variable    53230115
*** Keywords ***
Validar statuscode

    ${response}    GET    ${BASE_URL}${VALIDO_CEP} 
    Status Should Be    200    ${response}

Validar resposta json de cep valido
    ${response}    GET    ${BASE_URL}${VALIDO_CEP} 
    ${json}    Convert String To JSON    ${response.content}
    # Validações do JSON
    Should Be Equal As Strings    ${json["cep"]}    53230-200
    Should Be Equal As Strings    ${json["logradouro"]}    Rua Estudante Alfredo Cantalice
    Should Be Equal As Strings    ${json["bairro"]}    Vila Popular
    Should Be Equal As Strings    ${json["localidade"]}    Olinda
    Should Be Equal As Strings    ${json["uf"]}    PE
    Should Be Equal As Strings    ${json["estado"]}    Pernambuco
    Should Be Equal As Strings    ${json["regiao"]}    Nordeste
    Should Be Equal As Strings    ${json["ibge"]}    2609600
    Should Be Equal As Strings    ${json["ddd"]}    81
    Should Be Equal As Strings    ${json["siafi"]}    2491 
    Should Be Empty    ${json["complemento"]}    ${VAZIO}
    Should Be Empty    ${json["unidade"]}    ${VAZIO}
    Should Be Empty    ${json["gia"]}    ${VAZIO}

Validar statuscode cep 
    ${response}    GET    ${BASE_URL}${DIFERENTE_CEP}
    Status Should Be    200    ${response}
Validar cep diferente do esperado
    ${response}    GET    ${BASE_URL}${DIFERENTE_CEP}
    ${json}    Convert String To JSON    ${response.content}
    # Validações do JSON
    Should Not Be Equal As Strings    ${CEP_RECEBIDO}    ${CEP_ESPERADO}
Validar status de cep valido com traço
    ${response}    GET    ${BASE_URL}${VALIDO_CEP_TRACO}
    Status Should Be    200    ${response} 
Validar CEP invalido com 8 digitos
     #Verifica o statuscode sucesso
    ${response}    GET    ${BASE_URL}${INVALIDO_CEP}
    Status Should Be    200    ${response}
Validar mensagem de erro
    #Verifica se se campo erro veio com valor true
    ${response}    GET    ${BASE_URL}${INVALIDO_CEP}
    ${json}    Convert String To JSON    ${response.content}
    Should Be Equal As Strings    ${json["erro"]}    true

Validar status 400 com menos de 8 digitos
    #Criar sessão
    Criar Sessao    minha_sessao    ${BASE_URL}
    #GET para o CEP inválido
    ${response}=    Fazer Requisicao GET    ${INVALIDO_CEP_MENOR}
    Verificar Status Code    ${response}    ${STATUS_ESPERADO}

Validar Status 400 com mais de 8 digitos
    #Criar sessão
    Criar Sessao    minha_sessao    ${BASE_URL}
    #GET para o CEP inválido
    ${response}=    Fazer Requisicao GET    ${INVALIDO_CEP_MAIOR}
    Verificar Status Code    ${response}    ${STATUS_ESPERADO}

Validar CEP não informado
    Criar Sessao    minha_sessao    ${BASE_URL}
    #GET para o CEP inválido
    ${response}=    Fazer Requisicao GET    ${VAZIO_CEP}
    Verificar Status Code    ${response}    ${STATUS_404}
    
Criar Sessao
#Cria sessão HTTP
    [Arguments]    ${session_name}    ${url}
    Create Session    ${session_name}    ${url}

Fazer Requisicao GET
#Envia requisição
    [Arguments]    ${endpoint}
    ${response}=    Get Request    minha_sessao    ${endpoint}
    [Return]    ${response}

Verificar Status Code
#Verifica status
    [Arguments]    ${response}    ${STATUS_ESPERADO}
    Should Be Equal As Numbers    ${response.status_code}    ${STATUS_ESPERADO}



