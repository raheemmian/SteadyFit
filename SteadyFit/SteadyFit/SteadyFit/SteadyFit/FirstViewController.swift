//
//  FirstViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//

//Home
import UIKit
import Foundation
import MessageUI
import MapKit
import CoreLocation

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate{
    var myindex = 0;
    var locationManager = CLLocationManager()
    let items = [ ["Histogram"] , ["Event A", "Event B", "Event C"]]
    let sections = ["Activity Tracker", "Events"]
    @IBAction func EmergencyButton(_ sender: Any) {sendText()}
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.tableFooterView = UIView(frame: .zero)
        myTableView.delegate = self
        myTableView.dataSource = self
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
            locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    /*-----------------------------------Location----------------------------------------------------------------------*/
    /*-----------------------------------Table----------------------------------------------------------------------*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for:  indexPath)
        cell.textLabel?.text = items[indexPath.section][indexPath.row]
        return cell
    }
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: sections[indexPath.section], sender: self)
        //items[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.myTableView.indexPathForSelectedRow!
        if(indexPath.section == 0){
            let post = segue.destination as! HistogramViewController
            post.navigationItem.title = items[indexPath.section][indexPath.row]
        }
        else{
            let post = segue.destination as! UserEventsViewController
            post.navigationItem.title = items[indexPath.section][indexPath.row]
        }
    }
    /*-----------------------------------END OF Table----------------------------------------------------------------------*/
    /*-----------------------------------Messaging----------------------------------------------------------------------*/
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    func sendText() {
      //  let myLocation = CLLocationCoordinate2D(latitude: -1, longitude: -1)
//        let locValue:CLLocationCoordinate2D = locationManager
//        if (locationManager.location != nil) {
            let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
//        }
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = ["7788823644"]
        composeVC.body = "I need help! This is my current location: " + "http://maps.google.com/maps?q=\(locValue.latitude),\(locValue.longitude)&ll=\(locValue.latitude),\(locValue.longitude)&z=17"
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
     /*-----------------------------------END Messaging----------------------------------------------------------------------*/

}

