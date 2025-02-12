*** Settings ***

Resource                  viaCep.robot
Library    RequestsLibrary
Library    JSONLibrary

*** Test Cases ***

Cenario 01 - Verificar se todos os campos retornados pelo CEP valido estão corretos
    Validar statuscode
    Validar resposta json de cep valido

Cenario 02 - Verificar se todos os campos retornados pelo CEP que possui traço estão corretos
    Validar status de cep valido com traço
    Validar resposta json de cep valido
    
Cenario 03 - Verificar CEP invalido com 8 digitos
    Validar CEP invalido com 8 digitos
    Validar mensagem de erro

Cenario 04 - Verificar CEP invalido com menos de 8 digitos
    Validar status 400 com menos de 8 digitos

Cenario 05 - Verificar CEP invalido com mais de 8 digitos
    Validar status 400 com mais de 8 digitos

Cenario 06 - Verificar se o CEP retornado esta diferente do esperado
    Validar statuscode cep
    Validar cep diferente do esperado
Cenario 07 - Verificar CEP não informado
    Validar CEP não informado