// The Swift Programming Language
// https://docs.swift.org/swift-book

import NaturalLanguage
import Translation
import CoreML

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
