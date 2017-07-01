//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Richard H on 29/06/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    //load the image of the meme to the view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.image
    }


}
