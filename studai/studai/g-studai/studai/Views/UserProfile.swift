//
//  UserProfile.swift
//  studai
//
//  Created by Jose Morales on 3/16/24.
//

// TODO: delete user apple creds upon logout (keychain)

import SwiftUI

struct UserProfile: View {
    
    @StateObject var userAuth = UserAuth()
    @State private var isLoggedOut: Bool = false
    
    var greeting: String {
        let calendar = Calendar.current
        let currentTime = Date()
        
        let hour = calendar.component(.hour, from: currentTime)
        switch hour {
        case 6..<12:
            return "Good morning, ___!" // Assuming you have a property named username in UserAuth
        case 12..<18:
            return "Good afternoon, ___!" // Assuming you have a property named username in UserAuth
        default:
            return "Good evening, ___!" // Assuming you have a property named username in UserAuth
        }
    }
    
    var body: some View {
        NavigationView {
            NavigationStack {
                VStack {
                    Text(greeting) // Display greeting at the top of the view
                        .font(.title)
                        .padding()
                    
                    Button(action: {
                        // Add logout logic here
                        print("Logout button tapped")
                        
                        isLoggedOut = true
                        userAuth.isSignedIn = false
                        
                    }) {
                        Image(systemName: "arrowshape.turn.up.left.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red) // Customize the color of the icon
                    }
                    .padding()
                    .fullScreenCover( isPresented: $isLoggedOut){
                        ContentView()
                            .navigationBarBackButtonHidden(true)
                    }
                    
                    
                    List {
                        NavigationLink(destination: AssignmentsView()) {
                            HStack {
                                Image(systemName: "book.fill") // Symbol resembling assignments such as homework
                                    .foregroundColor(.blue)
                                Text("Assignments Page")
                            }
                        }
                        // Add more NavigationLinks for other pages/buttons as needed
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    Spacer()
                }
            }
        }
    }
}



#Preview {
    UserProfile()
}
