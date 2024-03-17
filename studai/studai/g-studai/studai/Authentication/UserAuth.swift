//
//  UserAuth.swift
//  studai
//
//  Created by Jose Morales on 3/16/24.
//

import Foundation
import SwiftUI

class UserAuth: ObservableObject{
    @AppStorage("isSignedIn") var isSignedIn: Bool = false
}
