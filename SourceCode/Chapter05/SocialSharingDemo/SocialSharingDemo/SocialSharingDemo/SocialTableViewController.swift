//
//  SocialTableViewController.swift
//  SocialSharingDemo
//
//  Created by Simon Ng on 5/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import FacebookShare
import TwitterKit

class SocialTableViewController: UITableViewController {

    var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery", "Haigh's Chocolate", "Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
    
    var restaurantImages = ["Cafe Deadend.jpg", "homei.jpg", "teakha.jpg", "Cafe Loisl.jpg", "petiteoyster.jpg", "For Kee Restaurant.jpg", "posatelier.jpg", "Bourke Street Bakery.jpg", "haighschocolate.jpg", "palominoespresso.jpg", "upstate.jpg", "traif.jpg", "grahamavenuemeats.jpg", "wafflewolf.jpg", "Five Leaves.jpg", "Cafe Lore.jpg", "Confessional.jpg", "Barrafina.jpg", "Donostia.jpg", "royaloak.jpg", "CASK Pub and Kitchen.jpg"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return restaurantNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SocialTableViewCell

        // Configure the cell...
        cell.featuredImageView.image = UIImage(named: restaurantImages[indexPath.row])
        cell.nameLabel.text = restaurantNames[indexPath.row]

        return cell
    }
    
    // MARK: - Action Methods
    
    @IBAction func share(_ sender: AnyObject) {
        
        // Get the selected row
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else {
            return
        }
        
        
//        let content = URL(string: "https://www.appcoda.com")!
//        let objectsToShare = [content]
//        let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        present(activityController, animated: true, completion: nil)
        
        
        // Display the share menu
        let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .actionSheet)
        
        let twitterAction = UIAlertAction(title: "Twitter", style: .default) { (action) in
            
            let selectedImageName = self.restaurantImages[indexPath.row]
            
            guard let selectedImage = UIImage(named: selectedImageName) else {
                return
            }
            
            let composer = TWTRComposer()

            composer.setText("Love this restaurant!")
            composer.setImage(selectedImage)

            composer.show(from: self, completion: { (result) in
                if (result == .done) {
                    print("Successfully composed Tweet")
                } else {
                    print("Cancelled composing")
                }
            })

        }
        
        let facebookAction = UIAlertAction(title: "Facebook", style: .default) { (action) in
            
            let selectedImageName = self.restaurantImages[indexPath.row]
            
            guard let selectedImage = UIImage(named: selectedImageName) else {
                return
            }
            
            let photo = Photo(image: selectedImage, userGenerated: false)
            let content = PhotoShareContent(photos: [photo])
            
//            let content = LinkShareContent(url: URL(string: "https://www.appcoda.com")!)
            let shareDialog = ShareDialog(content: content)
            
            do {
              try shareDialog.show()
            } catch {
                print(error)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        shareMenu.addAction(twitterAction)
        shareMenu.addAction(facebookAction)
        shareMenu.addAction(cancelAction)
        
        self.present(shareMenu, animated: true, completion: nil)
        
    }
    
    private func composeTweet() {
        let composer = TWTRComposerViewController.emptyComposer()
    }
}
