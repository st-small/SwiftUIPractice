//
//  Trivia.swift
//  TriviaGameDemo
//
//  Created by Stanly Shiyanovskiy on 13.08.2022.
//

import Foundation

struct Trivia: Codable {
    let results: [Result]
    
    struct Result: Codable, Identifiable {
        var id: UUID { UUID() }
        let category: String
        let type: String
        let difficulty: String
        let question: String
        let correctAnswer: String
        let incorrectAnswers: [String]
        
        var formattedQuestion: AttributedString {
            do {
                return try AttributedString(markdown: question)
            } catch {
                print("Error setting formattedQuestion: \(error)")
                return ""
            }
        }
        
        var answers: [Answer] {
            do {
                let text = try AttributedString(markdown: correctAnswer)
                let correct = [Answer(text: text, isCorrect: true)]
                let incorrects = try incorrectAnswers.map { answer in
                    Answer(text: try AttributedString(markdown: answer), isCorrect: false)
                }
                let allAnswers = correct + incorrects
                
                return allAnswers.shuffled()
            } catch {
                print("Error setting answers: \(error)")
                return []
            }
        }
    }
}
