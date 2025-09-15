//
//  MovieRowView.swift
//  MovieList
//
//  Created by German Marquez on 14/09/2025.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(movie.title)
                .bold()
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier("name")
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                    .font(.subheadline)
                Text(String(movie.year))
                    .font(.subheadline)
                    .accessibilityIdentifier("year")
                Spacer()
                Image(systemName: "clock")
                    .font(.caption)
                Text("ID: " + movie.id)
                    .font(.caption)
                    .accessibilityIdentifier("imdb")
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Color.clear
        )
        .overlay(content: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        })
        .foregroundColor(.white)
    }
}

struct MovieRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.init(white: 1, alpha: 0.15)))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                }
            )
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    MovieRowView(movie: Movie(id: "id01", title: "Movie 01", year: 2000))
}
