//
//  Movie.swift
//  MovieList
//
//  Created by German Marquez on 13/09/2025.
//
import Foundation

struct Movie: Identifiable, Decodable {
    let id: String
    let title: String
    let year: Int

    private enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
    }
}
