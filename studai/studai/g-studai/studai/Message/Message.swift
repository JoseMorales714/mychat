//
//  Message.swift
//  studai
//
//  Created by Jose Morales on 3/6/24.
//

import Foundation


struct Message: Identifiable {
    var id: UUID = UUID()
    var content: String
    var isUser: Bool
}
