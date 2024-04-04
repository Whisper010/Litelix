//
//  File.swift
//  
//
//  Created by Linar Zinatullin on 03/04/24.
//

import Foundation
import Fluent
import Vapor

struct UserController: RouteCollection {
    
    //API for get, post and put request
    func boot(routes: Vapor.RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        users.post(use: register)
        
        users.get(use: index)
        users.get(":username", use: find)
        
        users.put(use: update)
        
    }
    
    // post
    func register(req: Request) async throws -> User {
        let newUser = try req.content.decode(User.self)
            
        let existingUser = try await User.query(on: req.db)
            .filter(\.$username == newUser.username)
            .first()
        
        guard existingUser == nil else {
            throw Abort(.badRequest, reason: "Username already exists.")
        }
        
        try await newUser.save(on: req.db)
        
        return newUser
    }
    
    // get
    func index(req: Request) async throws -> [User]{
        try await User.query(on: req.db)
            .all()
    }
    
    
    func find(req: Request) async throws -> User{
        guard let user = try await User.find(req.parameters.get("username"), on: req.db) else {
            throw Abort(.badRequest)
        }
        return user
    }
    
    //put
    
    func update(req: Request) async throws -> User{
        let user = try req.content.decode(User.self)
        
        guard let userToUpdate = try await User.find(req.parameters.get("username"), on: req.db) else {
            throw Abort(.badRequest)
        }
        
        userToUpdate.username = user.username
        userToUpdate.password = user.password
        
        try await userToUpdate.update(on: req.db)
        return userToUpdate
    }
    
    
}
