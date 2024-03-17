//
//  ContentView.swift
//  studai
//
//  Created by Jose Morales on 3/6/24.
//

import SwiftUI
import SwiftData
import OpenAI
import Foundation
import AuthenticationServices

// TODO: as the user, let them choose chatbot color (green, black, etc.)
// TODO: change "chats" to use "chatStream"
// TODO: keep api key 1035
// TODO: API KEY PERMISSION to restricted
// TODO: use serverless function call for AI responses
    // this will help secure API key due to only fetching the response


struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var userAuth = UserAuth()
    
    @AppStorage("email") var email : String = ""
    @AppStorage("firstName") var firstName : String = ""
    @AppStorage("lastName") var lastName : String = ""
    @AppStorage("userId") var userId : String = ""
    
    @State private var password: String = ""
    @State private var isRegistering: Bool = false // Track whether user is registering
    @State private var isSignedIn: Bool = false
    
    var body: some View {
        
        if !userAuth.isSignedIn{
            Group{
                NavigationStack {
                    VStack {
                        Spacer()
                        Image(systemName: "person.circle")
                            .font(.system(size: 100))
                            .foregroundColor(.blue)
                            .padding()
                            
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(10)
                            .padding()
                            .autocapitalization(.none)
                            .foregroundColor(.white)
                            
                        SecureField("Password", text: $password)
                            .padding()
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(10)
                        .padding()
                        .foregroundColor(.white) // Text color set to white
                        
                    Button(action: {
                        // Add login functionality here
                    }) {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                        
                    Text("Register Account").onTapGesture {
                        isRegistering = true
                    }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .navigationDestination(isPresented: $isRegistering) {
                        RegisterUserView()
                    }
                        
                        SignInWithAppleButton(.signIn) { request in
                                
                            request.requestedScopes = [.email, .fullName]
                                
                        } onCompletion: { result in
                                
                            switch result{
                            case .success(let auth):
                                switch auth.credential{
                                    case let credential as
                                ASAuthorizationAppleIDCredential:
                                    let userId = credential.user
                                    
                                    let email = credential.email
                                    let firstName = credential.fullName?.givenName
                                    let lastName = credential.fullName?.familyName
                                        
                                    self.userId = userId
                                    self.email = email ?? ""
                                    self.firstName = firstName ?? ""
                                    self.lastName = lastName ?? ""
                                    
                                    
                                    userAuth.isSignedIn = true
                                        
                                default:
                                    break
                                }
                                    
                                    
                            case .failure(let error):
                                print(error)
                            }
                                
                        }
                        .signInWithAppleButtonStyle(
                            colorScheme == .dark ? .white : .black)
                        .frame(height: 60)
                        .padding()
                        .onAppear {
                            print("** Value of isSignedIn:", isSignedIn)
                        }
                        .navigationDestination(isPresented: $isSignedIn) {
                            UserProfile()
                        }
                    Spacer()
                    }
                    .padding()
                    // end of navigation stack block
                }
            }
        }else{
            AIchat()
        }
    }
}


#Preview {
    ContentView()
}
