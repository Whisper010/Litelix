//
//  File.swift
//  
//
//  Created by Linar Zinatullin on 03/04/24.
//

import Foundation
import Vapor
import Fluent

// User model and its properties

final class User: Model, Content {
    
    static let schema: String = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    init() {}
    
    init(id: UUID? = nil, username: String , password: String){
        self.id = id
        self.username = username
        self.password = password
    }
}
