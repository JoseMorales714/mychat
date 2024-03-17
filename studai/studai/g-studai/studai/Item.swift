//
//  Item.swift
//  studai
//
//  Created by Jose Morales on 3/6/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
