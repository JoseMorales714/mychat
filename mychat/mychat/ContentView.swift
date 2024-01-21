//
//  ContentView.swift
//  mychat
//
//  Created by Jose Morales on 1/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var is_not_signed_in: Bool = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                ChatScreen()
            }
            .navigationTitle("Convo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        print("user returned from chat")
                    } label: {
                        Text("Return")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $is_not_signed_in){
            SignInScreen()
        }
    }
}

struct ContentView_Previews : PreviewProvider {
    // static because it is shared among the struct
    static var previews: some View {
        ContentView()
    }
}
