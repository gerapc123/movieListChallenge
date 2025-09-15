//
//  Network.swift
//  MovieList
//
//  Created by German Marquez on 14/09/2025.
//

import Foundation

struct MoviesResponse: Decodable {
    let page: Int
    let total: Int
    let total_pages: Int
    let data: [Movie]
}

enum NetworkError: Error {
    case url
    case decoding
}

class Services {
    static func getMovies(page: Int, title: String?, year: String?) async throws -> MoviesResponse {
        guard var components = URLComponents(string: "https://jsonmock.hackerrank.com/api/moviesdata/") else {
            throw NetworkError.url
        }
        var parameters = ["page": String(page)]
        if let year = year { parameters["Year"] = year }
        if let title = title { parameters["Title"] = title }
        
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let moviesUrl = components.url else {
            throw NetworkError.url
        }
        
        let response: MoviesResponse = try await Network.makeRequest(from: moviesUrl)

        return response
    }
}

struct Network {
    static func makeRequest<MovieResponse: Decodable>(from url: URL) async throws -> MovieResponse {
        let (data, _) = try await URLSession.shared.data(from: url)
        // TODO: handle http errors
        let decodedData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodedData
    }
}
