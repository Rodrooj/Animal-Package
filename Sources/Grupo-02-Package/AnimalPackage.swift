// The Swift Programming Language
// https://docs.swift.org/swift-book

import NaturalLanguage
import Translation
import CoreML

/// Class animalPackage
/// classe responsável por gerenciar qual é o animal e qual a linguagem do texto
public class AnimalPackage {
    
    // Instanciação do CreateML
    private let model: Animais3?
    
    // Init padrão, colocando o modelo treinado dentro da variável
    /// Init padrão público
    /// Responsável pela instanciação da classe, colocando nosso modelo treinado com uma configuração pronta
    /// Caso o modelo não seja encontrado ou dê erro, ele retorna um print e um modelo nil.
    ///
    /// Como utilizar (SwiftUI):
    /// ```swift
    ///     let animalPackage = AnimalPackage()
    /// ```
    ///
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
    /// Como utilizar (SwiftUI):
    /// ```swift
    ///     let animalPackage = AnimalPackage()
    ///     let qualAnimal = animalPackage.whatAnimal(descricao: "Esse animal é peludo e tem quatro patas")
    ///     Text("\(qualAnimal)")
    /// ```
    ///
    /// - Parameter descricao: Pega um conteúdo textual que descreve um animal
    /// - Returns : Retorna a descrição do animal (por enquanto)
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
    /// Como utilizar (SwiftUI):
    /// ```swift
    ///     let animalPackage = AnimalPackage()
    ///     let qualIdioma = animalPackage.whatLanguage(text: "Mamma mia!")
    ///     Text("\(qualIdioma)")
    /// ```
    ///
    /// - Parameter text: Pega o conteúdo de texto passado
    /// - Returns : Retorna o idioma do respectivo texto
    public func whatLanguage(text: String) -> String {
        let language = NLLanguageRecognizer.dominantLanguage(for: text)
        guard let languageName = language?.rawValue else { return "Não foi possível identificar o idioma" }
        return "O idioma é: \(languageName)"
    }
    
    
}
