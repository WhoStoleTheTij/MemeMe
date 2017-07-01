//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Richard H on 28/06/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [Meme]! {
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return applicationDelegate.memes
    }
    
    
    //Mark: reload the memes when the table view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.memes.count
    }

    
    //Mark: loop the arrray of memes and display in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath)
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    //Mark: display the selected meme in the meme view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let image = memes[(indexPath as NSIndexPath).row].memedImage
        
        let viewMemeController = self.storyboard?.instantiateViewController(withIdentifier: "ViewDetailViewController") as! MemeDetailViewController
        
        viewMemeController.image = image
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Meme List", style: UIBarButtonItemStyle.plain, target: nil, action:nil)
        self.navigationController?.pushViewController(viewMemeController, animated: true)
        
    }
    
    
}
