//
//  SignInScreen.swift
//  mychat
//
//  Created by Jose Morales on 1/16/24.
//

import SwiftUI

struct SignInScreen: View {
    var body: some View {
        VStack(spacing: 40){
            Image("sunset_bg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 400, maxHeight: 400, alignment: .top)
                .clipped()
            
            VStack(spacing: 30){
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Sign In with Apple")
                        .padding()
                        .foregroundColor(.primary)
                        .overlay{
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .stroke()
                                .foregroundColor(.primary)
                                .frame(width: 200)
                        }
                })
                
                Button(action: {}, label: {
                    Text("Register with email")
                        .padding()
                        .foregroundColor(.primary)
                        .overlay{
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .stroke()
                                .foregroundColor(.primary)
                                .frame(width: 200)
                        }
                })
            }.frame(width: 200)
            
        }
    }
}

#Preview {
    SignInScreen()
}


