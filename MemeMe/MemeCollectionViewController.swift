//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Richard H on 28/06/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //Collection of memes
    var memes: [Meme]! {
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return applicationDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
    }
    
    
    //Mark: force layout to invalidate on screen rotation so that collection view cells are resized
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.flowLayout.invalidateLayout()
        
    }
    
    
    //Mark: reload the data in the collection view when the view appears on the screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }

    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //Mark: return the number of memes in the memes array
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    //Mark: loop the collection of memes and display in the collection view
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memedImage
        // Configure the cell
    
        return cell
    }

    
    //Mark: display the meme in the display controller
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = memes[(indexPath as NSIndexPath).row].memedImage
        
        let viewMemeController = self.storyboard?.instantiateViewController(withIdentifier: "ViewDetailViewController") as! MemeDetailViewController
        
        viewMemeController.image = image
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Meme Grid", style: UIBarButtonItemStyle.plain, target: nil, action:nil)
        self.navigationController?.pushViewController(viewMemeController, animated: true)
    }
    
    //Mark: set the size of the cells depending on the width of the screen plus the margins
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let dimension = (self.view.frame.size.width - 6.0) / 3.0
        return CGSize(width: dimension, height: dimension)
    }
    
    //Mark: return minimum line spacing - called when layout is invalidated
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(3.0)
    }
    
    //Mark: return minimum interim spacing - called when layout is invalidated
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(3.0)
    }

}
