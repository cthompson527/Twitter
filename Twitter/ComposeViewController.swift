//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Cory Thompson on 2/27/16.
//  Copyright © 2016 Cory Thompson. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var composeTextField: UITextField!
    var screenName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        composeTextField.delegate = self
        
        if let screenName = screenName {
            composeTextField.text = "@\(screenName) "
        }
        composeTextField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onQuitButton(sender: AnyObject) {
        composeTextField.text = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSendButton(sender: AnyObject) {
        textFieldShouldReturn(composeTextField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == composeTextField {
            let tweetString = textField.text
            if let tweetString = tweetString {
                TwitterClient.sharedInstance.tweet(tweetString, completion: { (success, failure) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
        return false
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
