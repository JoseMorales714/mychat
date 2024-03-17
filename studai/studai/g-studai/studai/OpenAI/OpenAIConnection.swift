//
//  OpenAIConnection.swift
//  studai
//
//  Created by Jose Morales on 3/6/24.
//

import Foundation
import OpenAI


class OpenAIService: ObservableObject {
    
    @Published var messages: [Message] = []
    
    var nothing: String = ""
    // DEACTIVE THIS WHEN TRYING TO USE ACTUAL RESPONSE
    
    lazy var openAI: OpenAI = {
            let openAIKey = ProcessInfo.processInfo.environment["openAIKey"] ?? ""
        return OpenAI(apiToken: nothing) // openAIKey
        }()
    
    func sendNewPrompt(content: String){
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getAIResponse()
    }

    func getAIResponse(){
        openAI.chats(query: .init(model: .gpt3_5Turbo, messages: self.messages.map({Chat(role: .user, content: $0.content)}))) { result in
            
            switch result {
            case .success(let success):
                
                guard let choice = success.choices.first else{
                    return
                }
                
                let message = choice.message.content
                DispatchQueue.main.async{
                    self.messages.append(Message(content: message ?? "" , isUser: false))
                }
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
