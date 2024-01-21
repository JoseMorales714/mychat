//
//  DatabaseManger.swift
//  mychat
//
//  Created by Jose Morales on 1/16/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


enum getMessagesError: Error{
    case snapShotError
}

final class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    let ref_msg = Firestore.firestore().collection("ref_msg")
    
    func getMessages(completion: @escaping (Result<[Message], getMessagesError>) -> Void){
        ref_msg.order(by: "sentAt", descending: true).limit(to: 25).getDocuments{ snapshot, error in
            guard let snapshot = snapshot, error == nil else{
                completion(.failure(.snapShotError))
                return
            }
                    
            let docs = snapshot.documents
            
            var msgs = [Message]()
            for doc in docs{
                
                // TODO: utilize encoding and decoding for the below (json)
                let payload = doc.data()
                let text = payload["text"] as? String ?? "Error"
                let user_uid = payload["user_uid"] as? String ?? "Error"
                let photoUrl = payload["photoUrl"] as? String ?? "Error"
                let sentAt = payload["sentAt"] as? Timestamp ?? Timestamp()
                
                let msg = Message(user_uid: user_uid, text: text, photoUrl: photoUrl, sentAt: sentAt.dateValue())
                msgs.append(msg)
                
            }
            
        }
    }
    
    func store_msg_database(message: Message, completion: @escaping (Bool) -> Void){
        
        let payload = [
            "text": message.text,
            "uid": message.user_uid,
            "sentAt": Timestamp(date: message.sentAt)
            // did not include photoURL -> TODO:
            
            // any because the types above are mixed
        ] as [String: Any]
        
        ref_msg.addDocument(data: payload) { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
}
