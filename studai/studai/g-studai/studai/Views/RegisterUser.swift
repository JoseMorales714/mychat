//
//  RegisterUser.swift
//  studai
//
//  Created by Jose Morales on 3/6/24.
//

import Foundation
import SwiftUI

// TODO: connect firebase to handle register

struct RegisterUserView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "person.badge.plus")
                .font(.system(size: 100))
                .foregroundColor(.blue)
                .padding()
            
            TextField("Full Name", text: $fullName)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
                .autocapitalization(.none)
                .foregroundColor(.white)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
                .autocapitalization(.none)
                .foregroundColor(.white)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
                .autocapitalization(.none)
                .foregroundColor(.white)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
                .autocapitalization(.none)
                .foregroundColor(.white)
            
            Button(action: {
                // Add registration functionality here
            }) {
                Text("Register")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Register")
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct RegisterUserView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterUserView()
    }
}
