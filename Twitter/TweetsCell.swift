//
//  TweetsCell.swift
//  Twitter
//
//  Created by Cory Thompson on 2/21/16.
//  Copyright © 2016 Cory Thompson. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            descriptionLabel.text = tweet.text
            nameLabel.text = tweet.user.name!
            screennameLabel.text = "@\(tweet.user.screenName!)"
            posterImageView.setImageWithURL(tweet.user.profileImageURL!)
            
            let timePosted = tweet.timestamp
            let timeNowInterval = NSDate().timeIntervalSince1970
            let timeNow = NSDate(timeIntervalSince1970: timeNowInterval)
            let timeFromPost = Int(timeNow.timeIntervalSinceDate(timePosted!))
            if timeFromPost < 60 {
                timestampLabel.text = "\(timeFromPost)s"
            } else if timeFromPost < 3600 {
                timestampLabel.text = "\(Int(timeFromPost/60))m"
            } else {
                timestampLabel.text = "\(Int(timeFromPost/3600))h"
            }
            retweetLabel.text = "\(tweet.retweetCount)"
            likeLabel.text = "\(tweet.favoriteCount)"
            print(timeFromPost)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImageView.layer.cornerRadius = 4
        posterImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRetweetButton(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet.id!) { (success, failure) in
            if success {
                self.tweet.retweetCount = self.tweet.retweetCount + 1
                self.retweetLabel.text = "\(self.tweet.retweetCount)"
                self.retweetButton.setImage(UIImage(named: "Retweeted"), forState: .Normal)
            }
        }
    }
    
    @IBAction func onLikeButton(sender: AnyObject) {
        TwitterClient.sharedInstance.like(tweet.id!) { (success, failure) -> Void in
            if success {
                self.tweet.favoriteCount = self.tweet.favoriteCount + 1
                self.likeLabel.text = "\(self.tweet.favoriteCount)"
                self.likeButton.setImage(UIImage(named: "Liked"), forState: .Normal)
            }
        }
    }
}
