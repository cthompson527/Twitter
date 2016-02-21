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
    
    var tweet: Tweet! {
        didSet {
            descriptionLabel.text = tweet.text
            nameLabel.text = tweet.user.name!
            screennameLabel.text = "@\(tweet.user.screenName!)"
            posterImageView.setImageWithURL(tweet.user.profileURL!)
            
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
            print(timeFromPost)
            //dateFormatter.dateFormat
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
