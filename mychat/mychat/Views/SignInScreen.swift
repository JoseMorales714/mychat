//
//  SignInScreen.swift
//  mychat
//
//  Created by Jose Morales on 1/16/24.
//

import SwiftUI

struct SignInScreen: View {
    
    @Binding var showSignIn: Bool
    var body: some View {
        VStack(spacing: 40){
            Image("sunset_bg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 400, maxHeight: 400, alignment: .top)
            
            Spacer()
            
            VStack(spacing: 30){
                Button {
                    AuthManager.shared.signInWithApple{ result in
                        switch result {
                        case .success(_):
                            showSignIn = true
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Sign In with Apple")
                        .padding()
                        .foregroundColor(.primary)
                        .overlay{
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .stroke()
                                .foregroundColor(.primary)
                                .frame(width: 200)
                        }
                }
                .frame(width: 300)
                
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

struct SigninScreen_Previews : PreviewProvider{
    static var previews: some View{
        SignInScreen(showSignIn: .constant(true))
    }
}

