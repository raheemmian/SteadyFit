//
//  ChatsViewController.swift
//  SteadyFit
//
//  Created by Akshay Kumor on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var chatListTitle = ["Private Chats", "Group Chats"]
    var chatListContent = [["Chat a", "Chat b"], ["Chat X", "Chat Y"]]
    
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatListTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return chatListTitle[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListContent[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = chatListContent[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showChat", sender: self)
        chatListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.chatListTableView.indexPathForSelectedRow!
        let post = segue.destination as! PrivateChatViewController
        post.navigationItem.title = chatListContent[indexPath.section][indexPath.row]
    }
}
