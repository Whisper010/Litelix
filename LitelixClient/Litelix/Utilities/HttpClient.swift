//
//  HttpClient.swift
//  Litelix
//
//  Created by Linar Zinatullin on 03/04/24.
//

import Foundation

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

enum MIMEType: String {
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "Content-Type"
}

enum HttpError: Error {
    case badURL, badResponse
    case errorEncodingData, errorDecodingData
    case serverSideError(Int)
}

class HttpClient {
    private init() {}
    
    static let shared = HttpClient()
    
    private func performDataTask<T: Codable>(with request: URLRequest) async throws -> T {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HttpError.badResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw HttpError.serverSideError(httpResponse.statusCode)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
    }
    
    func fetch <T: Codable>(url: URL) async throws ->[T] {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        return try await performDataTask(with: request)
    }
    
    func sendRequest<T: Codable, U: Codable>(to url: URL, object: T? = nil, method: HttpMethod) async throws -> U {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        
        if let object = object, method == .post || method == .put {
            request.httpBody = try JSONEncoder().encode(object)
        }
        return try await performDataTask(with: request)
    }
}
