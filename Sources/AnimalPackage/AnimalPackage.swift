// The Swift Programming Language
// https://docs.swift.org/swift-book

import NaturalLanguage
import Translation
import CoreML
import Foundation

/// Class animalPackage
/// classe responsável por gerenciar qual é o animal e qual a linguagem do texto
///
/// ### Methods
/// Esta classe possui dois métodos:
/// - WhatAnimal: Método responsável por a partir de uma descrição fornecida em String, retornar qual é o animal.
/// - WhatLanguage: Método responsável por a partir de um texto fornecido em String, retornar qual o idioma do texto.
/// - Tokentizacao: Método responsável por tokenizar um texto, retornando um array de palavras e caracteres especiais.
/// - ValidateResponse: Método responsável por validar se a resposta do modelo está correta ou incorreta
/// - CalculateAccuracy: Método responsável por calcular a acurácia do modelo
/// - CreateNewDescription: Método responsável por adicionar novas descrições dos animais exisentes ao dicionário `newDescriptions`
///
/// ### Variables
/// *model* pela qual não possui acesso., responsável por armazenar no init o modelo ML pronto que o package possui
/// TotalPredictions: Variável que armazena quantas respostas o modelo deu ao longo da utilização
/// totalErros: Variável que armazena resultados de erros.
/// totalCorrect: Variável que armazena resultados de acertos.
/// newDescriptions: Dicionário para armazenar novas descrições no formato esperado {text:label}
///
///
/// ### Como implementar:
/// - Em swiftUI:
/// ```swift
///     let animalPackage = AnimalPackage()
///     let animal = animalPackage.whatAnimal("Tem quatro patas e é peludo") // Retorna cachorro
///     let idioma = animalPackage.whatLanguage("Mamma mia!") // Retorna it (italiano)
///
///     Text("O animal da descrição é: \(animal)")
///     Text("O idioma do texto é: \(idioma)")
/// ```
///
///
///
// MARK: SOBRE O MODELO
// O modelo foi treinado para reconhecer três classes de animais: (Cachorro, Peixe e Pássaro)
// O modelo foi treinado com textos baseados em descrições visuais e somente em português, ele responderá melhor a descrições visuais e textos contextualizados

// -- EXEMPLOS DE TESTES --
// "Tem escamas douradas" -> peixe
// "Possui lindas penas coloridas" -> passaro
// "Tem pelo curto e quatro patas" -> cachorro

// -- PADRÃO DE RESPOSTA --
// O modelo retorna o resultado da previsão sempre com a palavra em minúsuculo e sem acento

@available(iOS 18.0, macOS 15.0, *)
public class AnimalPackage {
    
    // Instanciação do CreateML
    private let model: Animais3?
    
    // TotalPredictions é a variável que armazena quantas respostas o modelo deu ao longo da utilização
    var totalPredictions: Int = 0
    
    //Variáveis que armazenam resultados de erros e acertos
    var totalErros: Int = 0
    var totalCorrect: Int = 0
    
    //Dicionário para armazenar novas descrições
    //Formato esperado {text:label}
    var newDescriptions: [[String:String]] = []
    
    // Init padrão, colocando o modelo treinado dentro da variável
    /// Init padrão público
    /// Responsável pela instanciação da classe, colocando nosso modelo treinado com uma configuração pronta
    /// Caso o modelo não seja encontrado ou dê erro, ele retorna um print e um modelo nil.
    public init(){
        do {
            self.model = try Animais3(configuration: MLModelConfiguration())
        } catch {
            print("Erro no modelo: \(error)")
            self.model = nil
        }
    }
    
    /// Função animal
    /// Função que pega o model treinado, analisa a descrição sobre o animal e prevê qual o animal
    /// Ela prevê somente ente cachorro, peixe e pássaro
    ///
    /// ### Como utilizar:
    /// - Em swiftUI:
    /// ```swift
    ///     let animalPackage = AnimalPackage()
    ///     let qualAnimal = animalPackage.whatAnimal(descricao: "Esse animal é peludo e tem quatro patas")
    ///     Text("\(qualAnimal)")
    /// ```
    ///
    /// - Parameter descricao: Pega um conteúdo textual que descreve um animal
    /// - Returns : Retorna a descrição do animal (por enquanto)
    @available(iOS 18.0, macOS 15.0, *)
    public func whatAnimal(descricao: String) -> String {
        guard let model = model else { return "Modelo não carregado" }
        let predicao: Animais3Output
        do {
            predicao = try model.prediction(text: "\(descricao)")
            totalPredictions+=1
            return predicao.label
        } catch {
            return "Erro: \(error)"
        }
    }
    
    /// Função idioma
    /// Responsável por definir qual o idioma provável de um texto
    /// Caso não dê certo, retorna uma String de não foi possível identificar.
    ///
    /// ### Como utilizar:
    /// - Em swiftUI:
    /// ```swift
    ///     let animalPackage = AnimalPackage()
    ///     let qualIdioma = animalPackage.whatLanguage(text: "Mamma mia!")
    ///     Text("\(qualIdioma)")
    /// ```
    ///
    /// - Parameter text: Pega o conteúdo de texto passado
    /// - Returns : Retorna o idioma do respectivo texto
    @available(iOS 18.0, macOS 15.0, *)
    public func whatLanguage(text: String) -> String {
        let language = NLLanguageRecognizer.dominantLanguage(for: text)
        guard let languageName = language?.rawValue else { return "Não foi possível identificar o idioma" }
        return "O idioma é: \(languageName)"
    }
    
    /// Função de tokenização
    /// Enumera as palavras de uma String e retorna um array com cada palavra e caracteres especiais.
    ///
    /// ### Como utilizar:
    /// - Em swiftUI:
    /// ```swift
    ///     let animalPackage = AnimalPackage()
    ///     let tokens = animalPackage.whatLanguage(text: "Mamma mia!")
    ///     VStack {
    ///         ForEach(tokens.indices, id: \.self) { i in
    ///             Text(tokens[i])
    ///         }
    ///     }
    /// ```
    ///
    /// - Parameter text: Texto que será tokenizado.
    /// - Returns: Um array de `String` representando as palavras e símbolos do texto.
    @available(iOS 18.0, macOS 15.0, *)
    public func tokentizacao(text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text
        var palavras: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            palavras.append(String(text[tokenRange]))
            return true
        }
        return palavras
    }
    
    //-- Função validação de respostas --
    //Essa função é responsável somente por calcular o total de respostas corretas e incorretas
    //A função deve receber como parâmetro true se a previsão do ML for correta e false caso a previsão seja incorreta
    /// Função de validar respostas e contabilizar acertos e erros
    /// Responsável por contabilizar o total de respostas corretas e incorretas do modelo
    ///
    /// ### Como utilizar:
    /// - Em swiftUI:
    /// ```swift
    ///    let animalPackage = AnimalPackage()
    ///    animalPackage.validateResponse(isCorrect: true) // Incrementa acertos
    ///    animalPackage.validateResponse(isCorrect: false) // Incrementa erros
    ///    Text("Total de acertos: \(animalPackage.totalCorrect)")
    ///    Text("Total de erros: \(animalPackage.totalErros)")
    ///    ```
    @available(iOS 18.0, macOS 15.0, *)
    public func validateResponse(isCorrect: Bool){
        if !isCorrect {
            totalErros+=1
        }else{
            totalCorrect+=1
        }
    }
    
    /// Função para calcular acurácia
    /// Função responsável por calcular o valor de acurácia do modelo
    ///
    /// ### Como utilizar:
    /// - Em swiftUI:
    /// ```swift
    ///   let animalPackage = AnimalPackage()
    ///   let accuracy = animalPackage.calculateAccuracy()
    ///   Text("Acurácia do modelo: \(accuracy)%")
    ///   ```
    ///
    ///   - Returns: Retorna a acurácia do modelo em porcentagem
    @available(iOS 18.0, macOS 15.0, *)
    public func calculateAccuracy() -> Double {
        return Double(totalCorrect)/Double(totalPredictions) * 100
    }
    
    /// Função para adicionar novas descrições
    /// Função responsável por adicionar novas descrições ao dicionário `newDescriptions`
    /// ### Como utilizar:
    /// - Em swiftUI:
    /// ```swift
    ///  let animalPackage = AnimalPackage()
    ///  animalPackage.createNewDescription(description: "Esse animal é peludo e tem quatro patas", animal: "cachorro")
    ///  ```
    ///  - Parameters:
    ///  - description: A descrição do animal a ser adicionada.
    ///  - animal: O nome do animal correspondente à descrição.
    ///  - Note: As novas descrições são armazenadas no formato {text:label} dentro do array `newDescriptions`.
    ///  - Important: Esta função serve para armazenar novas descrições dos animais existentes do modelo (cachorro, peixe e pássaro), mas não treina o modelo com elas.
    public func createNewDescription(description: String, animal: String){
        
        let text = description
        let label = animal
        
        let newDescription = [text:label]

        if (animal.compare("cachorro", options: .caseInsensitive) != .orderedSame) &&
            (animal.compare("peixe", options: .caseInsensitive) != .orderedSame) &&
            (animal.compare("passaro", options: .caseInsensitive) != .orderedSame) {
            
            newDescriptions.append(newDescription)
            print("Nova descricao adicionada")
            print(newDescriptions)
        } else {
            print("Animal inválido. Use 'cachorro', 'peixe' ou 'passaro'.")
        }

    }
}


