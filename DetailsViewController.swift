//
// Created by Phuong H on 7/11/16.
// Copyright (c) 2016 Phuong H. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var overviewLabel: UILabel!

  var posterUrl: String = ""
  var overviewStr: String = ""

  override func viewDidLoad() {
    super.viewDidLoad()

    posterImage.setImageWithURL(NSURL(string: posterUrl)!)
    overviewLabel.text = overviewStr
  }

}
