//
//  MessageContent.swift
//  mychat
//
//  Created by Jose Morales on 1/10/24.
//

import SwiftUI

struct MessageContent: View {
    
    var message : Message
    
    var body: some View {
        if(message.is_from_current_user()){
            is_current_user_func(message : message)
        }else{
            is_not_current_user_func(message: message)
        }
    }
}

struct MessageContent_Previews : PreviewProvider {
    // static because it is shared among the struct
    static var previews: some View {
        MessageContent(message: Message(user_uid: "123", text: "yoyo", photoUrl: "www", sentAt : Date()))
    }
}

func is_current_user_func(message: Message) -> some View{
    HStack{
        HStack{
            // message.text field accessing
            Text(message.text)
                .padding()
        }
        // instead of 260, use formula
        .frame(maxWidth: 260, alignment: .topLeading)
        .background(.gray)
        .cornerRadius(10)
        
        // this gives system icons for UI
        Image(systemName: "person")
            .frame(maxHeight: 30, alignment: .top)
            .padding(.bottom, 15)
            .padding(.leading, 4)
    }
    .frame(maxWidth: 360, alignment: .trailing)
}

func is_not_current_user_func(message: Message) -> some View{
    HStack{
        // this gives system icons for UI
        Image(systemName: "person")
            .frame(maxHeight: 30, alignment: .top)
            .padding(.bottom, 15)
            .padding(.trailing, 4)
        HStack{
            // message.text field accessing
            Text(message.text)
                .padding()
        }
        // instead of 260, use formula
        .frame(maxWidth: 260, alignment: .leading)
        .background(.gray)
        .cornerRadius(10)
    }
    .frame(maxWidth: 360, alignment: .leading)
}
