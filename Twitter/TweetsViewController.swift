//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Cory Thompson on 2/20/16.
//  Copyright © 2016 Cory Thompson. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello tweet view controller")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
            for tweet in tweets {
                print(tweet.text!)
            }
        }, failure: { (error: NSError) -> () in
            print(error.localizedDescription)
        })
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        
        // Do any additional setup after loading the view.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }) { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetsCell", forIndexPath: indexPath) as! TweetsCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if sender is UIButton {
            let buttonPoint = sender?.convertPoint(CGPointZero, toView: tableView)
            let indexPath = tableView.indexPathForRowAtPoint(buttonPoint!)
            let tweet = tweets![indexPath!.row]
            
            if segue.destinationViewController is DetailUserViewController {
                let detailViewController = segue.destinationViewController as! DetailUserViewController
                detailViewController.user = tweet.user
            } else if segue.destinationViewController is ComposeViewController {
                let composeViewController = segue.destinationViewController as! ComposeViewController
                composeViewController.screenName = tweet.user.screenName
            }
        } else if segue.destinationViewController is DetailTweetViewController {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let detailTweetViewController = segue.destinationViewController as! DetailTweetViewController
            detailTweetViewController.tweet = tweets![indexPath!.row]
        }
    }
}
