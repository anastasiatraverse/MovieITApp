//
//  MovieDetailViewController.swift
//  MovieITApp
//
//  Created by Анастасия Траверсе on 20.04.2021.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movie:           Result = Result()
    var movieLiked:      Bool = false
    var movieLikedList:  [Result] = []
    
    @IBOutlet weak var moviePoster:     UIImageView!
    @IBOutlet weak var movieName:       UILabel!
    @IBOutlet weak var movieYear:       UILabel!
    @IBOutlet weak var movieRatings:    UILabel!
    @IBOutlet weak var movieLikeButton: UIButton!
    
    @IBAction func setLike(_ sender: Any) {
        movieLiked = !movieLiked
        if(movieLiked){
            movieLikeButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
            LikedMovies.shared.addLike(movie: movie)
        }else{
            movieLikeButton.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
            LikedMovies.shared.removeLike(movie: movie)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieLikedList = LikedMovies.shared.getAllLikes()
        setMovieDescription()
    }
    
    private func setMovieDescription(){
        self.movieName.text = movie.original_title!
        self.movieYear.text = "Release date: \(movie.release_date!)"
        self.movieRatings.text = String(movie.vote_average!) + "(\(String(movie.vote_count!)) votes)"
        self.moviePoster.imageFromURL(from: "https://image.tmdb.org/t/p/w500\(movie.poster_path!)")
        if (movieLikedList.contains(movie)){
            self.movieLikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
}
