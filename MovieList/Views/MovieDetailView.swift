//
//  MovieDetailView.swift
//  MovieList
//
//  Created by German Marquez on 14/09/2025.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie

    @Binding var isTapped: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(movie.title)
                .font(.largeTitle)
                .bold()
            Text("Year: \(movie.year)")
                .font(.title2)
                .foregroundColor(.secondary)
            Text("IMDb ID: \(movie.id)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Button(action: {
                isTapped.toggle()
            }) {
                Text(isTapped ? "Movie watched" : "Unseen movie")
                    .padding()
                    .background(isTapped ? Color.green : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
}
