//
//  Media.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 14/11/23.
//

import Foundation


struct Media: Identifiable, Decodable{
    
    let adult: Bool
    let id: Int
    let media_type: String?
    let poster_path: String?
    let name: String?
    let title: String?
    let overview: String
    let vote_average: Float
    let backdrop_path: String?
    let release_date: String?
    let genre_ids: [Int]
    
    var genreNames: [String] {
        let genres = GenreViewModel().genres
        var names: [String] = []
        for id in genre_ids {
              if let name = genres[id] {
                  names.append(name)
              }
          }
        return names
    }
    
    var titleName: String {
        return name == nil ? title ?? "" : name ?? ""
    }
    
    var releaseDate: String {
        return release_date ?? ""
    }
    
    var backdropURL: URL? {
        let baseURL = URL(string:"https://image.tmdb.org/t/p/w500")
        return baseURL?.appending(path: backdrop_path ?? "")
    }
    
    var posterThumbnail: URL? {
        let baseURL = URL(string:"https://image.tmdb.org/t/p/w500")
        return baseURL?.appending(path: poster_path ?? "")
    }
    var posterURL: URL? {
        let baseURL = URL(string:"https://image.tmdb.org/t/p/w500")
        return baseURL?.appending(path: poster_path ?? "")
    }
}


