//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by German Marquez on 13/09/2025.
//

import Foundation
import Combine

struct Paginator: Equatable {
    private(set) var currentPage: Int = 0
    private(set) var isLoading: Bool = false
    private(set) var hasMorePages: Bool = true
    private(set) var totalPages: Int = 0
    
    let itemsPerPage: Int = 10
    
    mutating func setTotalPages(_ total: Int) {
        self.totalPages = total
    }
    
    var canLoadNextPage: Bool {
        return !isLoading && hasMorePages && currentPage <= totalPages
    }
    
    mutating func startLoading() {
        isLoading = true
    }
    
    mutating func stopLoading() {
        isLoading = false
    }
    
    mutating func incrementPage() {
        currentPage += 1
    }
    
    mutating func setHasMorePages(_ value: Bool) {
        hasMorePages = value
    }
}

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isAscending = true
    @Published var searchText: String = ""
    @Published var buttonStates: [String: Bool] = [:]
    @Published var paginator = Paginator()
    var currentSort = SortType.none {
        didSet {
            applySort()
        }
    }
    var allMovies: [Movie] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        if let savedStates = UserDefaults.standard.object(forKey: "buttonStates") as? [String: Bool] {
            self.buttonStates = savedStates
        }
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchValue in
                guard let self = self else { return }
                if searchValue.isEmpty {
                    self.resetMovies()
                } else {
                    self.searchText(searchValue)
                }
            }
            .store(in: &cancellables)
    }
    
    func searchText(_ searchValue: String) {
        movies = allMovies.filter { $0.title.contains(searchText) || String($0.year).contains(searchText) }
    }
    
    func loadNextPage() {
        if paginator.canLoadNextPage && searchText.isEmpty{
            fetchNextPage(paginator.currentPage + 1)
        }
    }
    
    private func fetchNextPage(_ page: Int, year: String? = nil, title: String? = nil) {
        guard !paginator.isLoading else { return }
        paginator.startLoading()
        Task {
             do {
                 let moviesResponse = try await Services.getMovies(page: page, title: nil, year: nil)
                 paginator.incrementPage()
                 if moviesResponse.total_pages == 0 {
                     paginator.setHasMorePages(false)
                 }
                 if paginator.currentPage == 1 {
                     paginator.setTotalPages(moviesResponse.total_pages)
                 }
                 proccessMoviesData(moviesResponse.data)
             } catch {
                 self.paginator.stopLoading()
             }
         }
    }
    
    private func proccessMoviesData(_ moviesData: [Movie]) {
        paginator.stopLoading()
        allMovies.append(contentsOf: moviesData)
        movies = allMovies
        applySort()
    }
    
    func saveButtonStates() {
        UserDefaults.standard.set(buttonStates, forKey: "buttonStates")
    }
}

extension MovieListViewModel {
    enum SortType {
        case title
        case year
        case none
    }
    
    func orderMovies() {
        if currentSort == .none {
            currentSort = .title // make title default if previous state is .none
        } else {
            isAscending.toggle()
            applySort()
        }
    }

    func resetMovies() {
        searchText = ""
        currentSort = .none
    }
    
    func applySort(_ type: SortType) {
        currentSort = type
    }
    
    private func applySort() {
        switch currentSort {
        case .title:
            movies.sort { isAscending ? $0.title < $1.title : $0.title > $1.title }
        case .year:
            movies.sort { isAscending ? $0.year < $1.year : $0.year > $1.year }
        case .none:
            movies = allMovies
        }
    }
}
