//
//  MovieLikedViewController.swift
//  MovieITApp
//
//  Created by Анастасия Траверсе on 20.04.2021.
//

import UIKit

class MovieLikedViewController: UIViewController, UITabBarControllerDelegate {
    var movieLiked :  [Result] = []
    var selectedRow : Int = 0

    @IBOutlet weak var movieLikedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieLiked = LikedMovies.shared.getAllLikes()
        movieLikedTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        movieLiked = LikedMovies.shared.getAllLikes()
        movieLikedTableView.reloadData()

        self.tabBarController?.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieLikedDetail" {
            if let movieViewController = segue.destination as?  MovieDetailViewController {
                movieViewController.movie = movieLiked[selectedRow]
            }
        }
    }

}

extension MovieLikedViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieLiked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if movieLiked.count>0{
            let cell = movieLikedTableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
            cell.movieName.text = self.movieLiked[indexPath.row].original_title!
            cell.moviePoster?.imageFromURL(from: "https://image.tmdb.org/t/p/w500\(self.movieLiked[indexPath.row].poster_path!)")
            cell.movieLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.movieLike.tag = indexPath.row
            cell.movieLike.addTarget(self, action: #selector(handleLikeClick(sender:)), for: .touchUpInside)
            return cell
        }else{
            let cell = UITableViewCell()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showMovieLikedDetail", sender: self)
    }
    
    @objc fileprivate func handleLikeClick(sender: UIButton) {
        if(movieLiked.contains(movieLiked[sender.tag])){
            sender.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
            LikedMovies.shared.removeLike(movie: movieLiked[sender.tag])
            movieLiked.remove(element: movieLiked[sender.tag])
            self.movieLikedTableView.reloadData()
        }
    }
}
