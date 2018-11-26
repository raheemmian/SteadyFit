//
//  PendingRequestViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-11-24.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class PendingRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var requestTableSections = ["Friend Request", "Group Request"]
    var requestTableContents = [["Friend 1", "Friend 2","Friend 3"],["Group 1", "Group 2","Group 3"]]
    
//    let cellID = "cellID"
    @IBOutlet weak var requestTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async() {
            // Check how many times the table is loaded
            print ("loaded table\n")
            self.requestTableView.reloadData()
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//        let frameWidth: CGFloat = self.view.frame.width
//        let frameHeight: CGFloat = self.view.frame.height
//        requestTableView.frame = CGRect(x: 0, y: barHeight, width: frameWidth, height: frameHeight - barHeight)
//        requestTableView.register(RequestTableViewCell.self, forCellReuseIdentifier: cellID)
        requestTableView.dataSource = self
        requestTableView.delegate = self
//        self.view.addSubview(requestTableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return requestTableSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return requestTableSections[section]
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestTableContents[section].count
    }
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    let declineButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Decline", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = requestTableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath)
        
        cell.contentView.addSubview(acceptButton)
        cell.contentView.addSubview(declineButton)
        
        
        acceptButton.rightAnchor.constraint(equalTo: declineButton.leftAnchor, constant: -15).isActive = true
        acceptButton.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        acceptButton.widthAnchor.constraint(equalTo: self.acceptButton.widthAnchor).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: cell.frame.height).isActive = true
        
        declineButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10).isActive = true
        declineButton.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        declineButton.widthAnchor.constraint(equalTo: self.acceptButton.widthAnchor).isActive = true
        declineButton.heightAnchor.constraint(equalToConstant: cell.frame.height).isActive = true
        
        acceptButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        declineButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        cell.textLabel?.text = requestTableContents[indexPath.section][indexPath.row]
        return cell
    }
    
    @objc func buttonAction(sender: UIButton!){
        acceptButton.isEnabled = false
        declineButton.isEnabled = false
        
        if(sender == acceptButton){
            print("Accept button is clicked")
            declineButton.isHidden = true
            acceptButton.setTitle("Joined", for: .normal)
            // update database regarding to which button is clicked
            // potentially refresh view so the group disappear from this view
            
        }
        else if(sender == declineButton){
            print("Decline button is clicked")
            acceptButton.isHidden = true
            declineButton.setTitle("Declined", for: .normal)
            
            // update database regarding to which button is clicked
            // potentially refresh view so the group disappear from this view
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

