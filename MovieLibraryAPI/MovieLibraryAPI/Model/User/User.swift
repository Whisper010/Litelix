//
//  User.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 22/11/23.
//

import Foundation
import SwiftData

@Model
class User{
    @Attribute(.unique) var id: Int
    @Attribute(.unique) var userName: String
    var password: String
    var icon: String
    
    init(id: Int, userName: String, password: String, icon: String) {
        self.id = id
        self.userName = userName
        self.password = password
        self.icon = icon
    }
    
    
}
