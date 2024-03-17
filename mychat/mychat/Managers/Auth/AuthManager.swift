//
//  AuthManager.swift
//  mychat
//
//  Created by Jose Morales on 1/16/24.
//

import Foundation
import FirebaseAuth
import CryptoKit
// y
import AuthenticationServices


//extension UIApplication{
//}


struct chatUser {
    let uid: String
    let name: String
    let email: String?
    let photoUrl: String?
}



final class AuthManager: NSObject {
   
    
    
    static let shared = AuthManager()
    
    let auth =  Auth.auth()

    
    func getCurrentUser() -> chatUser? {
        guard let authUser = auth.currentUser else{
            return nil
        }
        
        return chatUser(uid: authUser.uid, name: authUser.displayName ?? "not yet", email: authUser.email, photoUrl: authUser.photoURL?.absoluteString)
    }
    
   
        
    
    func signOut() throws{
        try auth.signOut()
    }

}
