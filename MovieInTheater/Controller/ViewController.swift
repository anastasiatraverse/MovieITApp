//
//  ViewController.swift
//  MovieITApp
//
//  Created by Анастасия Траверсе on 20.04.2021.
//

import UIKit

class ViewController: UIViewController{
    
    let apiKey = "055b0798d93b6c7c4b5b64df99ddca61"
//    let imageCache = NSCache<NSString, UIImage>()
        
    var selectedRow : Int = 0
    var moviesInfo: [Result] = []
    var moviesLike: [Result] = []
    
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        self.movieTableView.delegate = self
        self.movieTableView.dataSource = self
        super.viewDidLoad()
        moviesLike = LikedMovies.shared.getAllLikes()
        movieTableView.reloadData()
        makeMovieRequest(from: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(self.apiKey)&language=en-US&page=1")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        moviesLike = LikedMovies.shared.getAllLikes()
        movieTableView.reloadData()
    }
    
    func movieViewList(movieArray : [Result?]){
        for i in movieArray{
            moviesInfo.append(i!)
        }
        
        DispatchQueue.main.async {
            self.movieTableView.reloadData()
        }
    }
    
    func makeMovieRequest(from apiURL: String){
        guard let url = URL(string: apiURL) else{print("URL Error"); return}

        let task = URLSession.shared
        
        task.dataTask(with: url) { [self](data, response, error) in
            
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let movieRequestResult = try JSONDecoder().decode(MovieData.self, from: data)
                movieViewList(movieArray: movieRequestResult.results)
            }catch let error{
                print(error)
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMovieDetail" {
            if let movieViewController = segue.destination as?  MovieDetailViewController { 
                movieViewController.movie = moviesInfo[selectedRow]
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
        cell.movieName.text = self.moviesInfo[indexPath.row].original_title!
        cell.moviePoster?.imageFromURL(from: "https://image.tmdb.org/t/p/w500\(self.moviesInfo[indexPath.row].poster_path!)")
        if moviesLike.contains(moviesInfo[indexPath.row]){
            cell.movieLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        cell.movieLike.tag = indexPath.row
        cell.movieLike.addTarget(self, action: #selector(handleLikeClick(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showMovieDetail", sender: self)
    }
    
    @objc fileprivate func handleLikeClick(sender: UIButton) {
        moviesLike = LikedMovies.shared.getAllLikes()
        if(moviesLike.contains(moviesInfo[sender.tag])){
            sender.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
            LikedMovies.shared.removeLike(movie: moviesInfo[sender.tag])
            moviesLike.remove(element: moviesInfo[sender.tag])
        }else{
            sender.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
            LikedMovies.shared.addLike(movie: moviesInfo[sender.tag])
        }
    }
}

extension UIImageView{
    public func imageFromURL(from imageURL: String){
        guard let url = URL(string: imageURL) else {return}
        
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data:data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
