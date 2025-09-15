//
//  MovieListTests.swift
//  MovieListTests
//
//  Created by German Marquez on 13/09/2025.
//

import XCTest
@testable import MovieList

final class MovieListTests: XCTestCase {
    func loadMockJSON(filename: String) throws -> Data {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("File not found \(filename).json")
        }
        return try Data(contentsOf: url)
    }

    @MainActor
    func testSortMoviesByYearAscending() {
        do {
            let JSONData = try loadMockJSON(filename: "mockData")
            let movies = try JSONDecoder().decode([Movie].self, from: JSONData)
            
            let viewModel = MovieListViewModel()
            viewModel.movies = movies
            viewModel.isAscending = true
            viewModel.applySort(.year)
            
            XCTAssertEqual(viewModel.movies[0].year, 1990)
            XCTAssertEqual(viewModel.movies[9].year, 2011)
        }
        catch {
            XCTFail("Decoding error: \(error)")
        }
    }
    
    @MainActor
    func testSortMoviesByYearDescending() {
        do {
            let JSONData = try loadMockJSON(filename: "mockData")
            let movies = try JSONDecoder().decode([Movie].self, from: JSONData)
            
            let viewModel = MovieListViewModel()
            viewModel.movies = movies
            viewModel.isAscending = false
            viewModel.applySort(.year)

            XCTAssertEqual(viewModel.movies[0].year, 2011)
            XCTAssertEqual(viewModel.movies[9].year, 1990)
        }
        catch {
            XCTFail("Decoding error: \(error)")
        }
    }
    
    @MainActor
    func testSortMoviesByTitleAscending() {
        do {
            let JSONData = try loadMockJSON(filename: "mockData")
            let movies = try JSONDecoder().decode([Movie].self, from: JSONData)
            
            let viewModel = MovieListViewModel()
            viewModel.movies = movies
            viewModel.isAscending = true
            viewModel.applySort(.title)
            
            XCTAssertEqual(viewModel.movies[0].title, "Fighting, Flying and Driving: The Stunts of Spiderman 3")
            XCTAssertEqual(viewModel.movies[9].title, "Waterworld 4: History of the Islands")
        }
        catch {
            XCTFail("Decoding error: \(error)")
        }
    }
    
    @MainActor
    func testSortMoviesByTitleDescending() {
        do {
            let JSONData = try loadMockJSON(filename: "mockData")
            let movies = try JSONDecoder().decode([Movie].self, from: JSONData)
            
            let viewModel = MovieListViewModel()
            viewModel.movies = movies
            viewModel.isAscending = false
            viewModel.applySort(.title)

            XCTAssertEqual(viewModel.movies[0].title, "Waterworld 4: History of the Islands")
            XCTAssertEqual(viewModel.movies[9].title, "Fighting, Flying and Driving: The Stunts of Spiderman 3")
        }
        catch {
            XCTFail("Decoding error: \(error)")
        }
    }
}
