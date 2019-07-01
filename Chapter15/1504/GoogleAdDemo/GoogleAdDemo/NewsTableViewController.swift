//
//  NewsTableViewController.swift
//  GoogleAdDemo
//
//  Created by Simon Ng on 29/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NewsTableViewController: UITableViewController {
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        //adBannerView.adUnitID = "ca-app-pub-9126231954512363/2691564256"
        adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    var interstitial: GADInterstitial?
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9126231954512363/2503081745")
        // interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        
        // Remove the following line before you upload the app
        request.testDevices = [kGADSimulatorID]
        interstitial.load(request)
        interstitial.delegate = self

        return interstitial
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        let adRequest = GADRequest()
        adRequest.testDevices = [kGADSimulatorID, "71cab255ddfaf0fb693ccd382b883798b255bca4"]
        adBannerView.load(GADRequest())
        
        interstitial = createAndLoadInterstitial()
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
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        if indexPath.row == 0 {
            cell.postImageView.image = UIImage(named: "red-lights-lisbon")
            cell.postTitle.text = "Red Lights, Lisbon"
            cell.postAuthor.text = "TOM EVERSLEY (@tomeversley)"
            cell.authorImageView.image = UIImage(named: "appcoda-fav-logo")
            
        } else if indexPath.row == 1 {
            cell.postImageView.image = UIImage(named: "val-throrens-france")
            cell.postTitle.text = "Val Thorens, France"
            cell.postAuthor.text = "BARA ART (bara-art.com)"
            cell.authorImageView.image = UIImage(named: "appcoda-fav-logo")
            
        } else if indexPath.row == 2 {
            cell.postImageView.image = UIImage(named: "summer-beach-huts")
            cell.postTitle.text = "Summer Beach Huts, England"
            cell.postAuthor.text = "TOM EVERSLEY (@tomeversley)"
            cell.authorImageView.image = UIImage(named: "appcoda-fav-logo")
            
        } else {
            cell.postImageView.image = UIImage(named: "taxis-nyc")
            cell.postTitle.text = "Taxis, NYC"
            cell.postAuthor.text = "TOM EVERSLEY (@tomeversley)"
            cell.authorImageView.image = UIImage(named: "appcoda-fav-logo")
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adBannerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return adBannerView.frame.height
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewsTableViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            //self.tableView.tableHeaderView?.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            //self.tableView.tableHeaderView = bannerView
        }
                
        //tableView.tableHeaderView?.frame = bannerView.frame
        //tableView.tableHeaderView = bannerView
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}

extension NewsTableViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
}
