//
//  ContentView.swift
//  MovieList
//
//  Created by German Marquez on 13/09/2025.
//

import SwiftUI

struct MovieListView: View {
    let bgGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 10 / 255, green: 12 / 255, blue: 41 / 255), Color.black]),
        startPoint: .top,
        endPoint: .bottom
    )

    @ObservedObject var viewModel = MovieListViewModel()
    @State private var showFilterAlert = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                headerTitle
                initialLoadingView
                HeaderView(showFilterAlert: $showFilterAlert)
                    .environmentObject(viewModel)
                noDataView
                listView
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if viewModel.movies.isEmpty {
                    viewModel.loadNextPage()
                }
            }
            .alert("Sort By:", isPresented: $showFilterAlert) {
                sortAlert
            }
            .background(
                bgGradient
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .preferredColorScheme(.dark)
    }

    var headerTitle: some View {
        HStack(alignment: .center) {
            Text("Movie List")
                .font(.title3)
                .foregroundStyle(Color.white)
                .padding()
                .accessibilityIdentifier("load-more-progress")
        }
        .frame(height: 40)
    }
    
    @ViewBuilder var initialLoadingView: some View {
        if viewModel.paginator.isLoading && viewModel.movies.isEmpty {
            ProgressView()
                .scaleEffect(3)
                .tint(.white)
                .padding(.top, 20)
        }
    }
    
    @ViewBuilder var loadingFooterView: some View {
        if viewModel.paginator.isLoading && !viewModel.movies.isEmpty {
            ProgressView()
                .scaleEffect(2)
                .tint(.white)
                .padding()
                .accessibilityIdentifier("load-more-progress")
        }
    }
    
    @ViewBuilder var noDataView: some View {
        if !viewModel.paginator.isLoading && viewModel.movies.isEmpty {
            VStack(spacing: 2) {
                Text("No data to display")
                    .font(.title)
                    .foregroundStyle(Color.white)
                Button("Clear Filters", action: viewModel.resetMovies)
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(Color.white)
                    .padding()
            }
            .padding(.top, 10)
        }
    }
    
    var listView: some View {
        VStack {
            List {
                ForEach(Array(viewModel.movies.enumerated()), id: \.element.id) { index, movie in
                    let isTapped = Binding<Bool>(
                        get: {
                            viewModel.buttonStates[movie.id] ?? false
                        },
                        set: { newValue in
                            viewModel.buttonStates[movie.id] = newValue
                            viewModel.saveButtonStates()
                        }
                    )
                    
                    NavigationLink(destination: MovieDetailView(
                        movie: movie,
                        isTapped: isTapped
                    )) {
                        MovieRowView(movie: movie)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .onAppear {
                                if movie.id == viewModel.movies.last?.id {
                                    viewModel.loadNextPage()
                                }
                            }
                    }
                    .accessibilityIdentifier("movies-item-\(index)")
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .accessibilityIdentifier("movie-list")
            loadingFooterView
        }
    }

    var sortAlert: some View {
        HStack(spacing: 20) {
            Button("Title") {
                viewModel.applySort(.title)
            }
            Button("Year") {
                viewModel.applySort(.year)
            }
        }
        .frame(maxHeight: 100)
        .padding()
    }
}

#Preview {
    MovieListView()
}
