//
//  ViewController.swift
//  Instagram
//
//  Created by Phuong H on 7/10/16.
//  Copyright © 2016 Phuong H. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!

  var movies = [NSDictionary]()
  let baseUrl: String = "https://image.tmdb.org/t/p/w342/"

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self

    let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
    let request = NSURLRequest(
      URL: url!,
      cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData,
      timeoutInterval: 10)
    let session = NSURLSession(
      configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
      delegate: nil,
      delegateQueue: NSOperationQueue.mainQueue())

    // Display HUD right before the request is made
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)

    let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {
      (dataOrNil, response, error) in
      print(error?.localizedDescription)

      if (error != nil) {
        let alert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
      }

      MBProgressHUD.hideHUDForView(self.view, animated: true)

      if let data = dataOrNil {
        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
          data, options: []) as? NSDictionary {
          self.movies = responseDictionary["results"] as! [NSDictionary]
          self.tableView.reloadData()
        }
      }
    })
    task.resume()
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
    cell.titleLabel.text = movies[indexPath.row]["title"] as! String
    cell.overviewLabel.text = movies[indexPath.row]["overview"] as! String

    let url = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
    cell.poster.setImageWithURL(NSURL(string: url)!)

    return cell
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let nextViewController = segue.destinationViewController as! DetailsViewController

    let indexPath = tableView.indexPathForSelectedRow
    nextViewController.overviewStr = movies[indexPath!.row]["overview"] as! String
    nextViewController.posterUrl = baseUrl + (movies[indexPath!.row]["poster_path"] as! String)
  }


}
