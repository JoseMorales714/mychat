//
//  AIchat.swift
//  studai
//
//  Created by Jose Morales on 3/16/24.
//


// TODO: "" should not be able to send empty message
// TODO:

import SwiftUI

struct AIchat: View {
    
    @StateObject var openAIService: OpenAIService = .init()
    @State var user_string: String = ""
    
    @AppStorage("email") var email: String = ""
    @State private var isHome: Bool = false
    
    var body: some View {
        
        
        Group {
            NavigationStack {
                VStack{
                    ScrollView{
                        ForEach(openAIService.messages){
                            message in MessageView(message: message)
                                .padding(8)
                        }
                    }
                    
                    Divider()
            
                    HStack{
                        TextField("Prompt:", text: self.$user_string, axis: .vertical)
                            .padding(4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(20)
                        Button{
                            self.openAIService.sendNewPrompt(content: user_string)
                            user_string = ""
                            
                        }label: {
                            Image(systemName: "paperplane")
                        }
                    }
                    .padding()
                    
                    Spacer() // Add a spacer to push the button to the bottom
                            
                            Button(action: {
                                isHome = true
                            }) {
                                Image(systemName: "house")
                            }
                            }
                .sheet(isPresented: $isHome) {
                                UserProfile() // Present UserProfile when isUserProfileActive is true
                            }
                }
            }
        }
    }
    



struct MessageView: View {
    
    var message: Message
    
    var body: some View {
        Group{
            if message.isUser{
                HStack{
                    Spacer()
                    Text(message.content)
                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
            }else{
                HStack{
                    Text(message.content)
                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        Spacer()
                }
            }
        }
    }
}


#Preview {
    AIchat()
}
