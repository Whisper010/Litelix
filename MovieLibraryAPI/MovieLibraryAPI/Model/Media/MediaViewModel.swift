//
//  MovieDBViewModel.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 13/11/23.
//

import Foundation
import SwiftUI

@MainActor
class MediaViewModel: ObservableObject {
    
    @Published var trendingMovies: [Media] = []
    @Published var trendingTVs: [Media] = []
    
    @Published var ratedMovies: [Media] = []
    @Published var ratedTVs: [Media] = []
    
    @Published var upcomingMovies: [Media] = []
    @Published var onTheAirTVs: [Media] = []
    
    @Published var popularMovies: [Media] = []
    @Published var popularTVs: [Media] = []
    
    @Published var airingTVs: [Media] = []
    
    @Published var searchResults: [Media] = []
    
    @Published var genresMovie: [Genre] = []
    @Published var genresTV: [Genre] = []
    
    let dateFormatter = DateFormatter()
    let currentDate = Date()
    let calendar = Calendar.current
    
    init(){
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5NjcyNWU1NWZhMTk1OWM4NTY3MTZkZjM1MjMxOWU2ZiIsInN1YiI6IjY1NTI2OTc2ZDRmZTA0MDBjNDIwMzI5YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NLq7wKShcgQ81s4Dlxr0r33bowHBag-u6K9WnVTMwf8"
    ]
    
    func loadTrending(mediaType: MediaType) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/\(mediaType.rawValue)/day?language=en-US") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
                if mediaType == .movie{
                    self.trendingMovies = decodedResponse.results
                }else {
                    self.trendingTVs = decodedResponse.results
                }
                
            } else {
                print("Error: Non-success status code")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func loadRated(mediaType: MediaType) async{
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(mediaType.rawValue)/top_rated?language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
                
                if mediaType == .movie{
                    self.ratedMovies = decodedResponse.results
                }else {
                    self.ratedTVs = decodedResponse.results
                }
                
            } else {
                print("Error: Non-success status code")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadUpcomingMovies() async{
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
                
                
                if let timeForComparing  = calendar.date(byAdding: .month, value: -1, to: currentDate) {
                    self.upcomingMovies = decodedResponse.results
                        .compactMap{ media -> Media? in
                            guard let releaseDateString = media.release_date,
                                  let releaseDate = dateFormatter.date(from: releaseDateString),
                                  releaseDate > timeForComparing else {
                                return nil
                            }
                            return media
                        }
                        .sorted{media1, media2  in
                            guard let releaseDate1 = dateFormatter.date(from: media1.releaseDate),
                                  let releaseDate2 = dateFormatter.date(from: media2.releaseDate) else {
                                return false
                            }
                            return releaseDate1 > releaseDate2
                        }
                }
                
                

            } else {
                print("Error: Non-success status code")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    func loadOnTheAirTVs() async{
        
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/on_the_air?language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
                self.onTheAirTVs = decodedResponse.results
                    

            } else {
                print("Error: Non-success status code")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadPopular(mediaType: MediaType) async{
        
        guard let url = URL(string: "https://api.themoviedb.org/3/\(mediaType.rawValue)/popular?language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
                if mediaType == .movie{
                    self.popularMovies = decodedResponse.results
                }else {
                    self.popularTVs = decodedResponse.results
                }
                
            } else {
                print("Error: Non-success status code")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadAiringTVs() async{
        
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/airing_today?language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
                self.airingTVs = decodedResponse.results

            } else {
                print("Error: Non-success status code")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func search(term: String) async {
         
        guard let url = URL(string: "https://api.themoviedb.org/3/search/multi?query=\(term)&include_adult=false&language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
                self.searchResults = decodedResponse.results
                
            } else {
                print("Error: Non-success status code")
            }
        } catch {
            print("Error4: \(error.localizedDescription)")
        }
        
    }
    
    func loadGenres(mediaType: MediaType) async {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/\(mediaType.rawValue)/list?language=en") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                let decodedResponse = try JSONDecoder().decode(GenreResult.self, from: data)
                if mediaType == .movie{
                    self.genresMovie = decodedResponse.genres
                }else {
                    self.genresTV = decodedResponse.genres
                }
                
            } else {
                print("Error: Non-success status code")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    static var preview: Media {
        return Media(adult: false, id: 800158, media_type: "movie", poster_path: "/e7Jvsry47JJQruuezjU2X1Z6J77.jpg", name: nil, title: "The Killer", overview: "After a fateful near-miss, an assassin battles his employers, and himself, on an international manhunt he insists isn't personal.", vote_average: 6.882, backdrop_path: "/mRmRE4RknbL7qKALWQDz64hWKPa.jpg", release_date: "2023-10-25" ,genre_ids: [80,53])
    }
}

enum MediaType: String {
    case tv = "tv"
    case movie = "movie"
}




