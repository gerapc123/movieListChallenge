//
//  MovieListUITests.swift
//  MovieListUITests
//
//  Created by German Marquez on 13/09/2025.
//

import XCTest

final class MovieListUITests: XCTestCase {
    @MainActor
    func testIdentifiers() throws {
        let app = XCUIApplication()
        app.launch()
        Thread.sleep(forTimeInterval: 2.0)
        
        let movieList = app.collectionViews["movie-list"]
        XCTAssertTrue(movieList.waitForExistence(timeout: 3), "The movie list does not exist.")
        
        let firstCell = movieList.buttons["movies-item-0"]
        XCTAssertTrue(firstCell.exists, "The first row does not exist.")
        XCTAssertTrue(firstCell.staticTexts["name"].exists, "The first row title does not exist.")
        XCTAssertTrue(firstCell.staticTexts["year"].exists, "The first row year does not exist.")
        XCTAssertTrue(firstCell.staticTexts["imdb"].exists, "The first row year does not exist.")
        
        let count = movieList.buttons.count - 1
        let lastCell = movieList.buttons["movies-item-\(count)"]
        XCTAssertTrue(lastCell.staticTexts["name"].exists, "The last row title does not exist.")
        XCTAssertTrue(lastCell.staticTexts["year"].exists, "The last row year does not exist.")
        XCTAssertTrue(lastCell.staticTexts["imdb"].exists, "The last row year does not exist.")
    }

    @MainActor
    func testHeaderButtons() throws {
        let app = XCUIApplication()
        app.launch()
        Thread.sleep(forTimeInterval: 2.0)
        
        let sortButton = app.buttons["sortToggleButton"]
        XCTAssertTrue(sortButton.exists, "El botón de sort no se encuentra.")
        sortButton.tap()
        
        let orderButton = app.buttons["orderToggleButton"]
        XCTAssertTrue(orderButton.exists, "El botón de ordenar no se encuentra.")
        orderButton.tap()

        let resetButton = app.buttons["clearSortButton"]
        XCTAssertTrue(resetButton.exists, "El botón de resetear no se encuentra.")
        resetButton.tap()
    }

    @MainActor
    func testPagination() throws {
        let app = XCUIApplication()
        app.launch()
        
        let movieList = app.collectionViews["movie-list"]
        XCTAssertTrue(movieList.waitForExistence(timeout: 3), "The movie list does not exist.")
        
        let initialRowCount = movieList.buttons.count
        XCTAssertGreaterThan(initialRowCount, 8, "The initial number of rows is not what was expected.")

        let targetRow = movieList.buttons["movies-item-24"]
        while !targetRow.exists {
            movieList.swipeUp()
            Thread.sleep(forTimeInterval: 0.5)
        }
        XCTAssertTrue(targetRow.isHittable, "The target row did not become visible after scrolling.")
        let finalRowCount = movieList.buttons.count
        XCTAssertGreaterThan(finalRowCount, initialRowCount, "No new rows were added to the list after scrolling.")
    }

    func testSearch() throws {
        let app = XCUIApplication()
        app.launch()
        Thread.sleep(forTimeInterval: 2.0)

        let searchTextField = app.textFields["search-input"]
        XCTAssertTrue(searchTextField.exists)
        XCTAssertTrue(searchTextField.isHittable)

        searchTextField.tap()
        searchTextField.typeText("Italian Spiderman")
        
        let movieList = app.collectionViews["movie-list"]
        XCTAssertTrue(movieList.waitForExistence(timeout: 3), "The movie list does not exist.")
        
        let initialRowCount = movieList.buttons.count
        XCTAssertEqual(initialRowCount, 1, "Just one match for that search text.")
    }

}
