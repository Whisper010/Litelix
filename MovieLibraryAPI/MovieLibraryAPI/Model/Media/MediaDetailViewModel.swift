//
//  MovieDetailViewModel.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 16/11/23.
//

import Foundation
import SwiftUI

@Observable
class MediaDetailsViewModel {
    
    var credits: MovieCredits?
    var cast: [MovieCredits.Cast] = []
    var profiles: [CastProfile] = []
    
    let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5NjcyNWU1NWZhMTk1OWM4NTY3MTZkZjM1MjMxOWU2ZiIsInN1YiI6IjY1NTI2OTc2ZDRmZTA0MDBjNDIwMzI5YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NLq7wKShcgQ81s4Dlxr0r33bowHBag-u6K9WnVTMwf8"
    ]
    
    func movieCredits(for movie: Int) async{
        
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie))/credits?language=en-US") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                let decodedResponse = try JSONDecoder().decode(MovieCredits.self, from: data)
                self.credits = decodedResponse
                self.cast = self.credits?.cast.sorted(by: {$0.order < $1.order}) ?? []
                
            } else {
                print("Error: Non-success status code")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadCastProfiles() async{
            for member in cast{
            guard let url = URL(string: "https://api.themoviedb.org/3/person/\(member.id)?language=en-US") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                    let decodedResponse = try JSONDecoder().decode(CastProfile.self, from: data)
                    self.profiles.append(decodedResponse)
                    
                } else {
                    print("Error: Non-success status code")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
       
    }
}

struct CastProfile: Decodable, Identifiable{
    
    let birthday: String
    let id: Int
    let name: String
    let profile_path: String?
    
    var photoURL: URL? {
        let baseURL = URL(string:"https://image.tmdb.org/t/p/w500")
        return baseURL?.appending(path: profile_path ?? "")
    }

}

struct MovieCredits: Decodable{
    let id: Int
    let cast: [Cast]
    
    struct Cast: Decodable,Identifiable{
        let name: String
        let id: Int
        let character: String
        let order: Int
    }
}
