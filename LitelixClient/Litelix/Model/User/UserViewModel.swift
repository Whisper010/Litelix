//
//  UserViewModel.swift
//  Litelix
//
//  Created by Linar Zinatullin on 22/11/23.
//

import Foundation

enum CredentialsError: Error {
    case invalidPassword
    case userNotFound
    case userAlreadyExist
}

@Observable
class UserViewModel {
    var user: User?
    
    
    let baseURLString = Constants.baseURL + Endpoints.users
    
    func login(username: String, password: String) async throws {
        let urlString = baseURLString
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        guard let users: [User] = try? await HttpClient.shared.fetch(url: url)
        else {
            print("users are not fetched")
            return
        }
        guard let user = users.filter({$0.username == username}).first else {
            print("users are not found")
            throw CredentialsError.userNotFound
        }
        if user.password == password {
            DispatchQueue.main.async {
                self.user = user
            }
        } else {
            print("invalid password")
            throw CredentialsError.invalidPassword
        }
        
    }
   
  

    func register(username: String, password: String) async throws{
        let urlString = baseURLString
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        guard let users: [User] = try? await HttpClient.shared.fetch(url: url)
        else {
            print("users are not fetched")
            return
        }
        if users.filter({$0.username == username}).first != nil {
            print("user already exist")
            throw CredentialsError.userAlreadyExist
        }
        
        
        let userToSend = User(id: UUID(), username: username, password: password)
        let userResponse: User = try await HttpClient.shared.sendRequest(to: url, object: userToSend, method: .post)
        DispatchQueue.main.async {
            self.user = userResponse
        }
        
        
    }
}

