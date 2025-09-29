//
//  File.swift
//  RecognizedAnimal
//
//  Created by Filipi Romão on 26/09/25.
//

import Foundation
import CoreML


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
            let model = try MLModelAnimals(configuration: config)
            
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
