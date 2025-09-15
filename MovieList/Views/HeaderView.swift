//
//  HeaderView.swift
//  MovieList
//
//  Created by German Marquez on 14/09/2025.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var viewModel: MovieListViewModel
    @Binding var showFilterAlert: Bool
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        VStack(spacing: 10) {
            if !viewModel.paginator.isLoading || !viewModel.movies.isEmpty {
                searchbarView
                buttonsView
            }
        }
        .padding(.horizontal, 20)
    }
    
    var searchbarView: some View {
        ZStack(alignment: .leading) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                ZStack(alignment: .leading) {
                    if viewModel.searchText.isEmpty { // Custom White Placeholder
                        Text("Search Movies...")
                            .foregroundColor(.white)
                            .disableAutocorrection(true)
                    }
                    TextField("", text: $viewModel.searchText)
                        .foregroundColor(.white)
                        .disableAutocorrection(true)
                        .focused($isSearchFocused)
                        .accessibilityIdentifier("search-input")
                }
            }
            .onTapGesture {
                isSearchFocused = false
            }
            .padding(.horizontal, 6)
        }
        .frame(minHeight: 40)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        })
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor(white: 1, alpha: 0.05)))
        )
    }

    var buttonsView: some View {
        HStack(spacing: 12) {
            Button(action: { showFilterAlert.toggle() }) {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
            .buttonStyle(MovieRowButtonStyle())
            .accessibilityIdentifier("sortToggleButton")
            
            Button(action: viewModel.orderMovies) {
                let arrowDirection = viewModel.isAscending ? "arrow.up" : "arrow.down"
                Label("Order", systemImage: arrowDirection)
            }
            .buttonStyle(MovieRowButtonStyle())
            .accessibilityIdentifier("orderToggleButton")
            
            Button(action: viewModel.resetMovies) {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }
            .buttonStyle(MovieRowButtonStyle())
            .accessibilityIdentifier("clearSortButton")
        }
    }

}
