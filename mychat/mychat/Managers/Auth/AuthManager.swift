//
//  AuthManager.swift
//  mychat
//
//  Created by Jose Morales on 1/16/24.
//

import Foundation
import FirebaseAuth

// y
import CryptoKit
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
    
    // apple nonce
    private var currentNonce: String?
    
    private var completionHandler: ((Result<chatUser, AppleSignInError>) -> Void)? = nil
    
    func getCurrentUser() -> chatUser? {
        guard let authUser = auth.currentUser else{
            return nil
        }
        
        return chatUser(uid: authUser.uid, name: authUser.displayName ?? "not yet", email: authUser.email, photoUrl: authUser.photoURL?.absoluteString)
    }
    
    func signInWithApple(completion: @escaping (Result<chatUser, AppleSignInError>) -> Void){
        
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        guard let topVC = UIApplication.getTopViewController() else {
            completion.failure(.unableToGrabTopVC)
            return
        }
        

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce, let completionHandler = completionHandler else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
            guard let appleIDToken = appleIDCredential.identityToken, let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential, including the user's full name.
          let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                            rawNonce: nonce,
                                                            fullName: appleIDCredential.fullName)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
              guard let authResult = authResult, error == nil else{
                  completionHandler(.failure(.authSignInError))
                  return
              }
              
              let user = chatUser(uid: authResult.user.uid, name: authResult.user.displayName ?? "not yet", email: authResult.user.email, photoUrl: authResult.user.photoURL?.absoluteString)
              completionHandler(.success(user))
          }
        }
      }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
      }
    
    func signOut() throws{
        try auth.signOut()
    }

}

extension AuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor(frame: .zero)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}

extension UIApplication{
    class func getTopViewController (base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController{
        
    }
}
