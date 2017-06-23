//
//  SuperheroViewController.swift
//  flix
//
//  Created by Xiu Chen on 6/23/17.
//  Copyright © 2017 Xiu Chen. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
  
    
    var movies: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchMovies()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
            
//            let movie = movies[indexPath.row]
//            let title = movie["title"] as! String
//            let overview = movie["overview"] as! String
//            cell.titleLabel.text = title
//            cell.overviewLabel.text = overview
            
            
            let rating = movie["vote_average"] as! Double
            cell.ratingLabel.text = String(rating)
        }
        return cell
        
        
    }

    
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=e56c35f88f0c10beeb2d2b4e559eeb2a")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                // Alert when there is a network error
                let alertController = UIAlertController(title: "Movies Cannot Load", message: "Please check your connection", preferredStyle: .alert)
                
                // create a cancel action
                let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                }
                
                
                
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                
                //                // *** fix this code here!
                //                for movie in movies {
                //                    let title = movie["title"] as! String
                //                    print(title)
                //
                //                    self.allMovies = self.allMovies + (title as! String)
                //                }
                //                print(self.allMovies)
                self.movies = movies
                self.collectionView.reloadData()
                //self.refreshControl.endRefreshing()
            }
        }
        
        task.resume()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
