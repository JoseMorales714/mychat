//
//  Message.swift
//  mychat
//
//  Created by Jose Morales on 1/13/24.
//

import Foundation

// decodable because will be private later
// Date == "yyyy-MM-dd HH:mm:ss"

struct Message : Decodable, Identifiable {
    let id = UUID()
    let user_uid : String
    let text : String
    let photoUrl : String
    let sentAt : Date
    
    func is_from_current_user () -> Bool{
        return false
    }
}

