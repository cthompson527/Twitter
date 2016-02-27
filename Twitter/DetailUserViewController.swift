//
//  DetailUserViewController.swift
//  Twitter
//
//  Created by Cory Thompson on 2/26/16.
//  Copyright © 2016 Cory Thompson. All rights reserved.
//

import UIKit

class DetailUserViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePosterView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bannerPosterView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePosterView.setImageWithURL(user.profileImageURL!)
        bannerPosterView.setImageWithURL(user.profileBannerURL!)
        profilePosterView.layer.cornerRadius = 5
        profilePosterView.clipsToBounds = true
        nameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName!)"
        descriptionLabel.text = user.tagline
        followersCountLabel.text = "\(user.followersCount)"
        followingCountLabel.text = "\(user.followingCount)"
        tweetCountLabel.text = "\(user.tweetsCount)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
