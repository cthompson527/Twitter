//
//  DetailTweetViewController.swift
//  Twitter
//
//  Created by Cory Thompson on 2/26/16.
//  Copyright © 2016 Cory Thompson. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {
    
    @IBOutlet weak var profilePosterView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello from detailed tweet")
        
        profilePosterView.setImageWithURL(tweet.user.profileImageURL!)
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@\(tweet.user.screenName!)"
        tweetLabel.text = tweet.text
        //timestampLabel.text = tweet.timestamp.
        retweetCountLabel.text = "\(tweet.retweetCount)"
        likeCountLabel.text = "\(tweet.favoriteCount)"
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet.id!) { (success, failure) in
            if success {
                self.tweet.retweetCount = self.tweet.retweetCount + 1
                self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
                self.retweetButton.setImage(UIImage(named: "Retweeted"), forState: .Normal)
            }
        }
    }
    @IBAction func onReplyButton(sender: AnyObject) {
    }

    @IBAction func onLikeButton(sender: AnyObject) {
        TwitterClient.sharedInstance.like(tweet.id!) { (success, failure) -> Void in
            if success {
                self.tweet.favoriteCount = self.tweet.favoriteCount + 1
                self.likeCountLabel.text = "\(self.tweet.favoriteCount)"
                self.likeButton.setImage(UIImage(named: "Liked"), forState: .Normal)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destinationViewController is ComposeViewController {
            let composeViewController = segue.destinationViewController as! ComposeViewController
            composeViewController.screenName = tweet.user.screenName
        }
    }


}
