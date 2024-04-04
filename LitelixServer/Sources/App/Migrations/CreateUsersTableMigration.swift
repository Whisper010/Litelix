//
//  File.swift
//  
//
//  Created by Linar Zinatullin on 03/04/24.
//

import Foundation
import Fluent

struct CreateUsersTableMigration: AsyncMigration {
    
    // Create Table in Database
    
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("username", .string, .required)
            .field("password", .string, .required)
            .create()
    }
    
    // Remove table in Database
    func revert(on database: Database) async throws {
        try await database.schema("users")
            .delete()
    }
}
