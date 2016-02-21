//
//  Tweet.swift
//  Twitter
//
//  Created by Cory Thompson on 2/20/16.
//  Copyright © 2016 Cory Thompson. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var name: String?
    var screenname: String?
    var posterImagePath: NSURL?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: User!
    
    init(dictionary: NSDictionary) {
        //print("\(dictionary)")
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        print(dictionary)
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }

        let author = dictionary["user"] as! NSDictionary
        user = User(dictionary: author)
        //name = author["name"] as? String
        //screenname = author["screen_name"] as? String
        //posterImagePath = NSURL(string: author["profile_image_url_https"] as! String)
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }

}
