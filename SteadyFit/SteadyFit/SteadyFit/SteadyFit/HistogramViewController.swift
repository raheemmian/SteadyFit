//
//  HistogramViewController.swift
//  SteadyFit
//
//  Created by Akshay Kumar on 2018-11-16.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Akshay Kumar
//  List of Changes: N/A - Work in Progress
// Initiali

import UIKit

class HistogramViewController: UIViewController {
    @IBOutlet weak var ATBarweekly: BarChartActivityTracker!
    var histogram_data: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let dataEntries = generateDataEntries()
        ATBarweekly.dataEntries = dataEntries
        
    }
    
    func generateDataEntries() -> [BarEntry] {

        let sorted_data = histogram_data.sorted { (aDic, bDic) -> Bool in
            return aDic.key > bDic.key
        }
        let find_max_value = histogram_data.sorted { (aDic, bDic) -> Bool in
            return aDic.value > bDic.value
        }
        
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [BarEntry] = []
        var i:Int = 0
        for data in sorted_data {
            let val = data.value
            let height: Float = Float(val) / Float(find_max_value[0].value)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(-24*60*60*i))
            result.append(BarEntry(color: colors[i % colors.count], height: height, textValue: "\(val)", title: formatter.string(from: date)))
            i += 1
        }
        
        return result
    
        
    }
    
}



