//
//  MovieModel.swift
//  MovieInTheater
//
//  Created by Анастасия Траверсе on 26.07.2021.
//
import Foundation

struct MovieData:Decodable { 
    var results: [Result?]
}


struct Result:Decodable, Equatable{
    var id: Int?
    var original_title: String?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    var vote_average: Float?
    var vote_count: Int?
}
