//
//  ChatScreen.swift
//  mychat
//
//  Created by Jose Morales on 1/10/24.
//

import SwiftUI

class chatScreenModel: ObservableObject{
    // allows view model that array can change and will update change
    // to view model
    
    @Published var messages = [Message]()
    
    @Published var test_data = [
        Message(user_uid: "String", text: "String", photoUrl: "String", sentAt: Date()),
        Message(user_uid: "String", text: "String", photoUrl: "String", sentAt: Date()),
        Message(user_uid: "String", text: "String", photoUrl: "String", sentAt: Date()),
        Message(user_uid: "String", text: "String", photoUrl: "String", sentAt: Date()),
        Message(user_uid: "String", text: "String", photoUrl: "String", sentAt: Date()),
    ]
    
}

struct ChatScreen: View {
    @StateObject var chat_screen_model = chatScreenModel()
    @State var text = ""
    
    //
    var body: some View {
        VStack{
            ScrollView {
                VStack(spacing: 8){
                    ForEach(chat_screen_model.test_data) { message in
                        MessageContent(message: message)
                    }
                }
            }
            HStack {
                TextField("Howdy", text: $text, axis: .vertical)
                    .padding()
                Button{
                    print("send")
                } label: {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(uiColor: .systemGreen))
                        .cornerRadius(50)
                        .padding(.trailing)
                }
                
            }.background(Color(uiColor: .systemGray6))
        }
    }
}
    
struct ChatScreen_Previews: PreviewProvider{
    static var previews: some View{
        ChatScreen()
    }
}
