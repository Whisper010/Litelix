//
//  MovieDBViewModel.swift
//  Litelix
//
//  Created by Linar Zinatullin on 13/11/23.
//

import Foundation
import SwiftUI

@Observable
class MediaViewModel{
    
    var trendingMovies: [Media] = []
    var trendingTVs: [Media] = []
    
    var ratedMovies: [Media] = []
    var ratedTVs: [Media] = []
    
    var upcomingMovies: [Media] = []
    var onTheAirTVs: [Media] = []
    
    var popularMovies: [Media] = []
    var popularTVs: [Media] = []
    
    var airingTVs: [Media] = []
    
    var searchResults: [Media] = []
    
    var genresMovie: [Genre] = []
    var genresTV: [Genre] = []
    
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
    
    private func makeRequest(for url: URL) async throws -> Data{
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return data
    }
    
    func loadTrending(mediaType: MediaType) async {
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/trending/\(mediaType.rawValue)/day?language=en-US") else {
                print("Invalid URL")
                return
            }
            let data = try await makeRequest(for: url)
            let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
            if mediaType == .movie {
                self.trendingMovies = decodedResponse.results
            } else {
                self.trendingTVs = decodedResponse.results
            }
                
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadRated(mediaType: MediaType) async{
        do {
                guard let url = URL(string: "https://api.themoviedb.org/3/\(mediaType.rawValue)/top_rated?language=en-US&page=1") else {
                    print("Invalid URL")
                    return
                }

                let data = try await makeRequest(for: url)
                let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
                
                if mediaType == .movie {
                    self.ratedMovies = decodedResponse.results
                } else {
                    self.ratedTVs = decodedResponse.results
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
    }
    
    func loadUpcomingMovies() async{
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1") else {
                print("Invalid URL")
                return
            }
            
            let data = try await makeRequest(for: url)
            let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
            
            if let timeForComparing = calendar.date(byAdding: .month, value: -1, to: currentDate) {
                self.upcomingMovies = decodedResponse.results
                    .filter { media in
                        guard let releaseDateString = media.release_date,
                              let releaseDate = dateFormatter.date(from: releaseDateString) else {
                            return false
                        }
                        return releaseDate > timeForComparing
                    }
                    .sorted { $0.releaseDate > $1.releaseDate }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    func loadOnTheAirTVs() async{
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/tv/on_the_air?language=en-US&page=1") else {
                print("Invalid URL")
                return
            }
            
            let data = try await makeRequest(for: url)
            let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
            self.onTheAirTVs = decodedResponse.results
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadPopular(mediaType: MediaType) async{
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/\(mediaType.rawValue)/popular?language=en-US&page=1") else {
                print("Invalid URL")
                return
            }
            
            let data = try await makeRequest(for: url)
            let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
            if mediaType == .movie {
                self.popularMovies = decodedResponse.results
            } else {
                self.popularTVs = decodedResponse.results
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadAiringTVs() async{
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/tv/airing_today?language=en-US&page=1") else {
                print("Invalid URL")
                return
            }
            
            let data = try await makeRequest(for: url)
            let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
            self.airingTVs = decodedResponse.results
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func search(term: String) async {
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/search/multi?query=\(term)&include_adult=false&language=en-US&page=1") else {
                print("Invalid URL")
                return
            }
            
            let data = try await makeRequest(for: url)
            let decodedResponse = try JSONDecoder().decode(MediaResult.self, from: data)
            self.searchResults = decodedResponse.results
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func loadGenres(mediaType: MediaType) async {
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/genre/\(mediaType.rawValue)/list?language=en") else {
                print("Invalid URL")
                return
            }

            let data = try await makeRequest(for: url)
            let decodedResponse = try JSONDecoder().decode(GenreResult.self, from: data)
            if mediaType == .movie {
                self.genresMovie = decodedResponse.genres
            } else {
                self.genresTV = decodedResponse.genres
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




