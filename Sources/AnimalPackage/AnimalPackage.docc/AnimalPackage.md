# ``AnimalPackage``

Package responsável por analisar uma descrição de animal e analisar qual é o animal que está sendo descrito
Esse package também pode identificar qual o idioma da descrição dada.

## Overview

O package consta com um Modelo ML feito para analisar descrições de animais e retornar qual o respectivo animal da descrição
e permite analisar o idioma do texto fornecido. 

## Sobre o modelo

O Modelo ML criado, tem suporte para etiquetas de três animais somente no momento:
- Peixe
- Cachorro
- Passaro

## Disponibilidade

O package está disponível a partir de:
- MacOS 15
- iOS 18

## Topics

### Funções

O package atualmete conta com duas funções:
WhatAnimal: Responsável por manipular com CreateML qual é o animal a partir de uma descrição
- ``AnimalPackage/whatAnimal(descricao:nome:)``

WhatLanguage: Responsável por definir qual a linguagem daquela descrição ou de um texto
- ``AnimalPackage/whatLanguage(text:)``

Tokentização: Responsável por separar o texto em tokens, ou seja, separar as palavras do texto
- ``AnimalPackage/tokentizacao(text:)``

ValidateResponse: Responsável por validar a resposta do modelo se está correta ou não
- ``AnimalPackage/validateResponse(isCorrect:)``

CalculateAccuracy: Responsável por calcular a acurácia do modelo
- ``AnimalPackage/calculateAccuracy()``

CreateNewDescription: Responsável por criar uma nova descrição para os animais do modelo
- ``AnimalPackage/createNewDescription(description:animal:)``

