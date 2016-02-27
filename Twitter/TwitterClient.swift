//
//  TwitterClient.swift
//  Twitter
//
//  Created by Cory Thompson on 2/20/16.
//  Copyright © 2016 Cory Thompson. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "Q3j72VvKFp97efKZ1ugsf8x3y", consumerSecret: "wcHzV1ocHkgkVWmeADs0oIAKlX2S4VRSuHc7aGFGVosgZWjFo9")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func handleOpenURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                
                self.currentAccount({ (user: User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
                })
                
                
                
            }) { (error: NSError!) -> Void in
                self.loginFailure?(error)
        }
    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("I got a token!")
                
                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(url)
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                
                success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries)
                
                success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func retweet(id: String, completion: ((success: Bool, failure: NSError?) -> Void)) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(success: true, failure: nil)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(success: false, failure: error)
        })
    }
    
    func tweet(tweetString: String, completion: ((success: Bool, failure: NSError?) -> Void)) {
        POST("1.1/statuses/update.json", parameters: ["status":tweetString], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(success: true, failure: nil)
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(success: false, failure: error)
        }
    }
    
    func like(id: String, completion: ((success: Bool, failure: NSError?) -> Void)) {
        POST("1.1/favorites/create.json", parameters: ["id":id], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(success: true, failure: nil)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(success: false, failure: error)
        })
    }
}
