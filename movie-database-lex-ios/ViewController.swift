//
//  ViewController.swift
//  movie-database-lex-ios
//
//  Created by Morgan, Carter on 2/24/18.
//  Copyright © 2018 Carter Morgan Personal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    private var messages: [Message] = []
    
    lazy var model = LexService();
    
    @IBOutlet weak var userText: UITextField!
    
    @IBOutlet weak var send: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        userText.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
   
    @IBAction func textFieldTapped(_ sender: Any) {
        scrollToBottom()
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        performRequest()
    }
    
    func performRequest(){
        if let phrase = userText.text{
            userText.text = ""
            let message = Message(phrase, true)
            messages += [message]
            tableView.reloadData()
            let indexPath = NSIndexPath(row: self.messages.count-1, section: 0)
            tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            
            let request = model.generateRequest(phrase: phrase)

            model.sendRequestToLexService(request: request){text in
                DispatchQueue.main.async {
                    let message = Message(text, false)
                    self.messages += [message]
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
            }
        }
    }
    
    func scrollToBottom(){
        if messages.count > 0{
            let indexPath = NSIndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder
        performRequest()
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.bottomConstraint?.constant = 8.0
            } else {
                self.bottomConstraint?.constant = endFrame?.size.height ?? 8.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
            scrollToBottom()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell")!
        
        let message = messages[indexPath.row]
        
        cell.textLabel?.text = message.content
        
        cell.textLabel?.numberOfLines = 0;
        
        if message.userSent{
            cell.textLabel?.textAlignment = NSTextAlignment.right
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }else{
            cell.textLabel?.textAlignment = NSTextAlignment.left
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        return cell
    }


}

