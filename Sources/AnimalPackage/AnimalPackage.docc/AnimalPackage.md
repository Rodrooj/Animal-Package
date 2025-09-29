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

O package está disponível principalmente para:
- MacOS 26
- iOS 26

## Topics

### Funções

O package atualmete conta com duas funções:
WhatAnimal: Responsável por manipular com CreateML qual é o animal a partir de uma descrição
- ``AnimalPackage/whatAnimal(descricao:)``

WhatLanguage: Responsável por definir qual a linguagem daquela descrição ou de um texto
- ``AnimalPackage/whatLanguage(text:)``


