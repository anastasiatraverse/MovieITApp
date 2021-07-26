//
//  LikedMovies.swift
//  MovieInTheater
//
//  Created by Анастасия Траверсе on 26.07.2021.
//

import Foundation

class LikedMovies{
    static let shared = LikedMovies()
    var likedMoviesList: [Result] = []

    private init() {}
    
    func addLike(movie: Result){
        likedMoviesList.append(movie)
    }
    
    func getAllLikes()->[Result]{
        return likedMoviesList
        
    }
    func removeLike(movie: Result){
        self.likedMoviesList.remove(element: movie)
    }
    
}

extension Array where Element: Equatable {
    mutating func remove (element: Element) {
        if let i = self.firstIndex(of: element) {
            self.remove(at: i)
        }
    }
}
