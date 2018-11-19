//
//  GroupChatTableViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-04.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum, Alexa Chen
//  List of Changes: Work in Progress
//  Added table, arrays for settings, added emergency button and GPS related code
//
//  List of Bugs:
//  Order of messages may not show properly based on timestamps, need further implementation on reading current time.
//  Message will bleed out on the bubble chat box, need further implementation to get proper height for each message
//  Message from other senders does not align on the left side, need further implementation for such
//  If you download it on a iphone device the keyboard doesnt send the message after pressing return on the keyboard and the chat
//  bar doesnt show on the keyboard
//  GroupChatTableViewController.swift is created for chat UI with the help of the following YouTube Channel: Lets Build That App
//  URL: www.youtube.com/playlist?list=PL0dzCUj1L5JEfHqwjBV0XFb9qx9cGXwkq
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class GroupChatTableViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var getMessageHandle:DatabaseHandle?
    var chatID:String = ""//"Chat2s
    var myUserID = (Auth.auth().currentUser?.uid)
    var myUserName:String = ""//"Alexa"
    var rawMessages = [MessageLine]()
    let cellID = "cellID"
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    // Take message from user and return
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hard code title
        navigationItem.title = "Public Group: Vancouver, light"
        tabBarController?.tabBar.isHidden = true
        collectionView.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 65, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 65, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.bounces = true
        collectionView?.keyboardDismissMode = .interactive
        
//        setupKeyboard()
        setupInputComponents()
        setupKeyboardEvents()
        getMessageHandle = self.ref?.child("Chats").child(chatID).child("Messages").observe(DataEventType.value, with: {
            (receivesnapshot) in
            // reset messages
            self.rawMessages.removeAll()
            //loops all messages
            for messages in receivesnapshot.children.allObjects as! [DataSnapshot] {
                // TO DO: filter out messages that are old
                print (messages)
                guard let myline = messages.value as? [String: AnyObject] else {continue}
                let myChatLine = MessageLine()
                myChatLine.senderID = myline["senderID"] as?String
                myChatLine.senderName = myline["senderName"] as?String
                myChatLine.message = myline["message"] as?String
                myChatLine.timeStamp = myline["date"] as?String
                self.rawMessages.append(myChatLine)
            }
            
            // SORT message by time stamp
            self.rawMessages.sort(by: { $0.timeStamp!.compare($1.timeStamp!) == .orderedAscending })
            // raw messages is now sorted
            // testing to see if sort worked
            for obj in self.rawMessages {
                print(obj.timeStamp!)
            }
            DispatchQueue.main.async(){
                self.collectionView?.reloadData()
            }
        })
        let indexPath = IndexPath(item: self.rawMessages.count - 1, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: true)
    }
    
    /*
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
//        let yHeight = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height
//        view.addSubview(containerView)
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        containerView.backgroundColor = UIColor.black
        
//        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        containerView.addSubview(textField)
        textField.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        // Add button and set constraint
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendAction), for: UIControl.Event.touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(self.inputTextField)
        
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add a line to separate input box and the view above, and set constraint
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.darkGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
 
    override var inputAccessoryView: UIView? {
        get {
//            return inputContainerView
//        }
            let containerView = UIView()
//            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            containerView.backgroundColor = UIColor.black

            let textField = UITextField()
            textField.placeholder = "Enter message..."
            containerView.addSubview(textField)
            textField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)

            return containerView
        }

    }
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    */
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        DispatchQueue.main.async {
//            self.inputAccessoryView?.becomeFirstResponder()
//        }
//
//    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == inputTextField{
            return true
        }
        return false
    }
    
//    func setupKeyboard(){
//        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
    
    func setupKeyboardEvents() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardDidShowNotification,
            object: nil,
            queue: OperationQueue.main) { [weak self] notification in
                let info = notification.userInfo!
                let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                
                UIView.animate(withDuration: 0.2, animations: {
                    self?.containerViewBottomAnchor?.constant = -keyboardFrame.size.height
                    self?.view.layoutIfNeeded()
                })
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardDidHideNotification,
            object: nil,
            queue: OperationQueue.main) { [weak self] notificaiton in
                self?.containerViewBottomAnchor?.constant = 0
        }
    }
    
    
    @objc func showKeyboard(notification: NSNotification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        containerViewBottomAnchor?.constant = -keyboardRect.height
        showLatestMessage()
    }
    
    @objc func hideKeyboard(notification: NSNotification){
        containerViewBottomAnchor?.constant = 0
        showLatestMessage()
    }
    
    // Show latest message whenever inputTextField is clicked
    private func showLatestMessage(){
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: {(completed) in
            let indexPath = IndexPath(item: self.rawMessages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: true)
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rawMessages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCollectionViewCell
        let msg = rawMessages[indexPath.item]
        cell.textView.text = String(msg.message!)
        cell.bubbleWidthAnchor?.constant = estimateFrameSize(text: msg.message!).width + 30
        setupCell(cell: cell, message: msg)
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCollectionViewCell, message: MessageLine){
        if message.senderID == myUserID{
            // Outgoing message
            cell.bubbleView.backgroundColor = UIColor.blue
            cell.textView.textColor = UIColor.white
            cell.bubbleLeftAnchor?.isActive = false
            cell.bubbleRightAnchor?.isActive = true
            cell.profilePicView.isHidden = true
            cell.senderNameView.text = ""
            cell.senderNameView.isHidden = true
        }
        else{
            // Incoming message
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.textView.textColor = UIColor.black
            cell.bubbleLeftAnchor?.isActive = true
            cell.bubbleRightAnchor?.isActive = false
            cell.profilePicView.isHidden = false
            cell.senderNameView.isHidden = false
            cell.senderNameView.text = message.senderName
            print(cell.senderNameView.text)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 60
        if let text = rawMessages[indexPath.item].message{
            height = estimateFrameSize(text: text).height + 16
            
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    // Work in progress, trying to get estimate height and width for each chat box
    private func estimateFrameSize(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 3000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func setupInputComponents(){
        // Add UIView and set constraint, x,y,w,h
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Add button and set constraint
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendAction), for: UIControl.Event.touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add a line to separate input box and the view above, and set constraint
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.darkGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    // This function is called when "Send" is clicked
    @objc func sendAction(){
        /*
         if chatID == "Chat2"{// to be DELETED after TA has marked V1 source code
         let key:String = (ref!.child("Chats/\(chatID)/Senders/\(myUserID)/MessageLines").childByAutoId().key)!
         let post = ["date": getTodayString() ,
         "message": inputTextField.text as Any] as [String : Any]
         let childUpdates = ["/Chats/\(chatID)/Senders/\(myUserID)/MessageLines/\(key)/": post]
         ref?.updateChildValues(childUpdates)
         }*/
        if inputTextField.text != "" {
            let key:String = (ref!.child("Chats/\(chatID)/Messages").childByAutoId().key)!
            let post = ["date": getTodayString() ,
                        "senderID": myUserID!,
                        "senderName": myUserName,
                        "message": inputTextField.text as Any] as [String : Any]
            let childUpdates = ["/Chats/\(chatID)/Messages/\(key)/": post]
            ref?.updateChildValues(childUpdates)
            // Clear text field once sent
            self.inputTextField.text = nil
        }
        else{
            print("No message")
        }
    }
    
    //  Get timestamp when message is sent
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(format: "%02d",month!) + "-" + String(format: "%02d",day!) + " " + String(format: "%02d",hour!)  + ":" + String(format: "%02d",minute!) + ":" +  String(format: "%02d",second!)
        
        return today_string
    }
}
