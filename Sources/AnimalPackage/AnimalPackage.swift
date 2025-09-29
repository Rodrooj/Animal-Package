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
///
/// ### Bindings
/// A classe possui um único binding atualmente que é o *model* pela qual não possui acesso., responsável por armazenar no init o modelo ML pronto que o package possui
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
@available(iOS 18.0, macOS 15.0, *)
public class AnimalPackage {
    
    // Instanciação do CreateML
    private let model: Animais3?
    
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
    /// ### Como utilizar (SwiftUI):
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
            return "O animal é: \(predicao.label)"
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
}

//
//  File.swift
//  RecognizedAnimal
//
//  Created by Filipi Romão on 26/09/25.
//


// MARK: SOBRE O MODELO
// O modelo foi treinado para reconhecer três classes de animais: (Cachorro, Peixe e Pássaro)
// O modelo foi treinado com textos baseados em descrições visuais e somente em português, ele responderá melhor a descrições visuais e textos contextualizados

// -- EXEMPLOS DE TESTES --
// "Tem escamas douradas" -> peixe
// "Possui lindas penas coloridas" -> passaro
// "Tem pelo curto e quatro patas" -> cachorro

// -- PADRÃO DE RESPOSTA --
// O modelo retorna o resultado da previsão sempre com a palavra em minúsuculo e sem acento



class AnimalRecognize {
    
    //TotalPredictions é a variável que armazena quantas respostas o modelo deu ao longo da utilização
    var totalPredictions: Int = 0
    
    //Variáveis que armazenam resultados de erros e acertos
    var totalErros: Int = 0
    var totalCorrect: Int = 0
    
    //Dicionário para armazenar novas descrições
    //Formato esperado {text:label}
    var newDescriptions: [[String:String]] = []
    
    
    // MARK: - Função Principal
    // Esta função é responsável por conectar o Swift ao CoreML,
    // enviar o valor de entrada para o modelo de ML e retornar um resultado.
    // O valor de retorno é a predição do modelo.
    // O "label" representa a classificação do animal.

    func classifyAnimal(animalDescription: String) -> String{
        do{
            let config = MLModelConfiguration()
            let model = try Animais3(configuration: config)
            
            let prediction = try model.prediction(text: animalDescription)
            totalPredictions+=1
            return prediction.label
            
        }catch {
            print(error)
            return ""
        }
    }
    
    
    //-- Função validação de respostas --
    //Essa função é responsável somente por calcular o total de respostas corretas e incorretas
    //A função deve receber como parâmetro true se a previsão do ML for correta e false caso a previsão seja incorreta
    func validateResponse(isCorrect: Bool){
        if !isCorrect {
            totalErros+=1
        }else{
            totalCorrect+=1
        }
    }
    
    //-- Função calculateAccuracy --
    //Função responsável por calcular o valor de acurácia do modelo
    func calculateAccuracy() -> Double{
        return Double(totalCorrect)/Double(totalPredictions) * 100
    }
    
    func createNewDescrption(description: String, animal: String){
        
        var text = description
        var label = animal
        
        var newDescription = [text:label]
        
        newDescriptions.append(newDescription)
        
        print("Nova descricao adicionada")
        print(newDescriptions)
    }
    
    
    
    
}
