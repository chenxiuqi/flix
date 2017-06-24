//
//  WebViewController.swift
//  flix
//
//  Created by Xiu Chen on 6/23/17.
//  Copyright © 2017 Xiu Chen. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webViewWindow: UIWebView!
    
    var requestURL = "https://api.themoviedb.org/3/movie/"
    
    var movie: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            let movieID = movie["id"] as! Int
            
            let newRequestURL = "https://api.themoviedb.org/3/movie/" + String(movieID) + "/videos?api_key=e56c35f88f0c10beeb2d2b4e559eeb2a&language=en-US"
            
            let newUrl = URL(string: newRequestURL)!
            
            let request = URLRequest(url: newUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let oneMovie = dataDictionary["results"] as! [[String: Any]]
                    print(oneMovie)
                    let urlKey = oneMovie[0]["key"] as! String
                    print(urlKey)
                    
                    var url = "https://www.youtube.com/watch?v="
                    url = url + urlKey
                    print(url)
                    // Convert the url String to a NSURL object.
                    let requestURL = URL(string:url)
                    // Place the URL in  URL Request.
                    let request = URLRequest(url: requestURL!)
                    // Load Request into WebView as! URL
                    self.webViewWindow.loadRequest(request)
                }
            }
            
            task.resume()
        }
        
    
        
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
