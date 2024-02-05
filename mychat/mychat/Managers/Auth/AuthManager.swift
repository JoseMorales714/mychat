//
//  AuthManager.swift
//  mychat
//
//  Created by Jose Morales on 1/16/24.
//

import Foundation
import FirebaseAuth

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

enum AppleSignInError: Error{
    case unableToGrabTopVC
    case authSignInError
    case appleIDTokenError
}


final class AuthManager: NSObject {
    
    static let shared = AuthManager()
    
    let auth =  Auth.auth()
    let signInApple = SignInApple()
    
    
    func getCurrentUser() -> chatUser? {
        guard let authUser = auth.currentUser else{
            return nil
        }
        
        return chatUser(uid: authUser.uid, name: authUser.displayName ?? "not yet", email: authUser.email, photoUrl: authUser.photoURL?.absoluteString)
    }
    
    func signInWithApple(completion: @escaping (Result<chatUser, AppleSignInError>) -> Void){
        
        
        signInApple.initAppleSignIn{ [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let appleResult):
                // Initialize a Firebase credential, including the user's full name.
                let credential = OAuthProvider.appleCredential(withIDToken: appleResult.idToken,
                                                               rawNonce: appleResult.nonce,
                                                               fullName: appleResult.fullname)
                // Sign in with Firebase.
                strongSelf.auth.signIn(with: credential) { (authResult, error) in
                    guard let authResult = authResult, error == nil else{
                        completion(.failure(.authSignInError))
                        return
                    }
                    
                    let user = chatUser(uid: authResult.user.uid, name: authResult.user.displayName ?? "not yet", email: authResult.user.email, photoUrl: authResult.user.photoURL?.absoluteString)
                    completion(.success(user))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        

    }
    
    func signOut() throws{
        try auth.signOut()
    }

}



extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


extension UIApplication{
    class func getTopViewController (base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController{
            return getTopViewController(base: nav.visibleViewController)
        }else if let tab = base as? UITabBarController, let selected = tab.selectedViewController{
            return getTopViewController(base: selected)
        }else if let presented = base?.presentedViewController{
            return getTopViewController(base: presented)
        }
        
        return base
    }
}


