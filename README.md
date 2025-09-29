# AnimalPackage

Pacote Swift para classificação simples de descrições de animais e utilidades de linguagem natural. Desenvolvido como parte do Challenge 08 da Apple Developer Academy.

## Sobre o projeto
O AnimalPackage oferece:
- Classificação de descrições textuais para identificar o animal descrito (modelo treinado para: cachorro, peixe e pássaro).
- Detecção do idioma predominante em um texto.
- Tokenização de texto (separação em palavras e símbolos).
- Utilitários para validar acertos/erros e calcular acurácia ao longo do uso.
- Armazenamento de novas descrições (para referência/curadoria futura). 

> Observação: O modelo de ML foi treinado com descrições em português e responde melhor a descrições visuais e contextualizadas. O rótulo retornado pelo modelo é em minúsculas e sem acentos.

## Requisitos
- Swift Tools: 6.1+
- Plataformas:
  - iOS 18+
  - macOS 15+

## Instalação (Swift Package Manager)
Você pode adicionar este pacote ao seu projeto de duas formas:

- Pelo Xcode:
  1. File > Add Package Dependencies…
  2. Informe a URL do repositório deste pacote
  3. Selecione a versão desejada e conclua

- Editando o seu Package.swift:
```swift
// Dentro de dependencies
.package(url: "https://github.com/Rodrooj/Animal-Package", from: "1.0.0"),

// Dentro de targets > dependencies
.target(
    name: "SeuTarget",
    dependencies: [
        .product(name: "AnimalPackage", package: "<repositorio>")
    ]
)
```
