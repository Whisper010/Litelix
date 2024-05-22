//
//  User.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 22/11/23.
//

import Foundation

struct User: Identifiable, Codable{
    
    let id: UUID
    let username: String
    let password: String
    
}
