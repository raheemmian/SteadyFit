//
//  HistogramViewController.swift
//  SteadyFit
//
//  Created by Akshay Kumar on 2018-11-16.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar

//This functionality was implemented with the help of Minh Nguyen's tutorial at medium along with
//modifications to suit our implemention, the tutorial can be found at:
//https://medium.com/@leonardnguyen/build-your-own-chart-in-ios-part-1-bar-chart-e1b7f4789d70

//  Edited by: Akshay Kumar
//  List of Changes: Set up graph structure with hard code data
//
//  Edited by: Alexa Chen on 2018-11-19
//  List of Changes: Change histogram bar height to dynamic height; populated histogram with data from firebase
//
//  List of known bugs:
//  monthly view's text is squished together
//  naming of the view switch buttons inconsistent and confusing
//
//  HistogramViewController.swift is for the histogram to showcase the progress of the activity time, so that users can see their progress visually
//

import UIKit

class HistogramViewController: EmergencyButtonViewController {
    @IBOutlet weak var ATBarweekly: BarChartActivityTracker!
    var histogramMode: Int = 0 // 0-daily, 1-weekly, 2-monthly
    var dataEntries:[BarEntry] = []
    @IBOutlet weak var sortbyweekButton: UIButton!
    @IBOutlet weak var sortbymonthButton: UIButton!
    
    var histogramData: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Difference modes depending on how the user wants to see the activity progress
        if histogramMode == 1{
            dataEntries = generateWeeklyEntries()
        }
        else if histogramMode == 2{
            dataEntries = generateMonthlyEntries()
        }
        else{
            dataEntries = generateDataEntries()
        }
        ATBarweekly.dataEntries = dataEntries
    }
    
    func generateDataEntries() -> [BarEntry] {
        //creates an array of data for daily minute tracking for the histogram
        var result: [BarEntry] = []
        if histogramData.count != 0{
            let sortedData = histogramData.sorted { (aDic, bDic) -> Bool in
                return aDic.key > bDic.key
            }
            let find_max_value = histogramData.sorted { (aDic, bDic) -> Bool in
                return aDic.value > bDic.value
            }
            
            let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
            var i:Int = 0
            for data in sortedData {
                var date = Date()
                let currentDateFormatter = DateFormatter()
                currentDateFormatter.dateFormat = "yyyy-MM-dd"
                let currentDate = currentDateFormatter.date(from: data.key)
                let currentDateComponents = Calendar.current.dateComponents([.year], from: currentDate!)
                let todayDateComponents = Calendar.current.dateComponents([.year], from: date)
                if (currentDateComponents.year! < todayDateComponents.year!){
                    break;
                }
                let val = data.value
                let height: Float = Float(val) / Float(find_max_value[0].value)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMM"
                date.addTimeInterval(TimeInterval(-24*60*60*i))
                result.append(BarEntry(color: colors[i % colors.count], height: height, textValue: "\(val)", title: formatter.string(from: date)))
                i += 1
            }
            
        }
        return result
    }
    
    func generateWeeklyEntries() -> [BarEntry] {
        //creates an array of data for weekly minute tracking for the current month
        var result: [BarEntry] = []
        if histogramData.count != 0{
            
            let sortedData = histogramData.sorted { (aDic, bDic) -> Bool in
                return aDic.key > bDic.key
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let calendar = Calendar.current
            let currentDateComponents = calendar.dateComponents([.year, .month], from: Date())
            let startOfMonth = dateFormatter.calendar.date(from: currentDateComponents)
            
            var week_count:Int = 0
            
            let oldest = startOfMonth
            let today = Date()
            let todayComponents = Calendar.current.dateComponents([.weekOfMonth,.year,.month], from: today)
            let components = Calendar.current.dateComponents([.weekOfMonth], from: oldest!, to: today)
            week_count = (components.weekOfMonth ?? 0) + 1
            
            var weekly_data : [String: Int] = [:]
            for i in 0...week_count{
                let tempWeek:Date = Calendar.current.date(byAdding: .day, value: i*7, to: oldest!)!
                let tempComponents = Calendar.current.dateComponents([.weekOfMonth,.year,.month], from: tempWeek)
                if (tempComponents.year! >= todayComponents.year! && tempComponents.month! >= todayComponents.month! && tempComponents.weekOfMonth! > todayComponents.weekOfMonth!){
                    break;
                }
                let tempDateString = "Week" + String(tempComponents.weekOfMonth!) + " of " + String(tempComponents.month!)+"," + String(tempComponents.year!)
                weekly_data[tempDateString] = 0
            }
            
            
            for each in sortedData{
                let weekValue = dateFormatter.date(from: each.key)
                var tempComponents = Calendar.current.dateComponents([.weekOfMonth,.year,.month], from: weekValue!)
                let formattedKey = "Week" + String(tempComponents.weekOfMonth!) + " of " + String(tempComponents.month!)+"," + String(tempComponents.year!)
                if weekly_data[formattedKey] != nil{
                    let appendValue = each.value
                    weekly_data[formattedKey] = Int(weekly_data[formattedKey]!) + Int(appendValue)
                }
            }
            
            let find_max_value = weekly_data.sorted { (aDic, bDic) -> Bool in
                return aDic.value > bDic.value
            }
            let sorted_weekly_data = weekly_data.sorted { (aDic, bDic) -> Bool in
                return aDic.key > bDic.key}
            
            let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
            var i:Int = 0
            for data in sorted_weekly_data {
                let val = data.value
                let height: Float = Float(val) / Float(find_max_value[0].value)
                var barTitle = data.key
                barTitle.removeLast(11)
                result.append(BarEntry(color: colors[i % colors.count], height: height, textValue: "\(val)", title: barTitle))
                i += 1
            }
            
            return result
        }
        return result
    }
    
    func generateMonthlyEntries() -> [BarEntry] {
        //creates an array of data for monthly minute tracking for the histogram
        var result: [BarEntry] = []
        if histogramData.count != 0{
            let sortedData = histogramData.sorted { (aDic, bDic) -> Bool in
                return aDic.key > bDic.key
            }
            
            let oldest_month = sortedData[sortedData.count-1].key as String
            var month_count:Int = 0
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let oldest = dateFormatter.date(from: oldest_month)
            let today = Date()
            let todayComponents = Calendar.current.dateComponents([.year,.month], from: today)
            let components = Calendar.current.dateComponents([.month], from: oldest!, to: today)
            month_count = (components.month ?? 0) + 1
            
            var monthlyData : [String: Int] = [:]
            for i in 0...month_count{
                let tempMonth:Date = Calendar.current.date(byAdding: .month, value: i, to: oldest!)!
                let tempComponents = Calendar.current.dateComponents([.year,.month], from: tempMonth)
                if (tempComponents.year! >= todayComponents.year! && tempComponents.month! > todayComponents.month!){
                    break;
                }
                let tempDateString = String(tempComponents.year!) + "," + String(format: "%02d",tempComponents.month!)
                monthlyData[tempDateString] = 0
            }

            for each in histogramData{
                let appendValue = each.value
                let monthValue = dateFormatter.date(from: each.key)
                var tempComponents = Calendar.current.dateComponents([.year,.month], from: monthValue!)
                let formattedKey = String(tempComponents.year!) + "," + String(format: "%02d",tempComponents.month!)
                monthlyData[formattedKey] = Int(monthlyData[formattedKey]!) + Int(appendValue)
            }
            
            
            let find_max_value = monthlyData.sorted { (aDic, bDic) -> Bool in
                return aDic.value > bDic.value
            }
            
            let sortedMonthlyData = monthlyData.sorted {$0.key.localizedStandardCompare($1.key) == .orderedDescending}
            
            let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
            var i:Int = 0
            for data in sortedMonthlyData {
                let val = data.value
                let height: Float = Float(val) / Float(find_max_value[0].value)
                result.append(BarEntry(color: colors[i % colors.count], height: height, textValue: "\(val)", title: data.key))
                i += 1
            }
        }
        return result
        
        
    }
    
    @IBAction func week_click(_ sender: Any) {
        // user clicks on the button to show weekly view
        histogramMode = 1
        dataEntries = generateWeeklyEntries()
        ATBarweekly.dataEntries = dataEntries
    }
    
    @IBAction func month_click(_ sender: Any) {
        // user clicks on the button to show monthly view
        histogramMode = 2
        dataEntries = generateMonthlyEntries()
        ATBarweekly.dataEntries = dataEntries
    }
    
    @IBAction func day_click(_ sender: Any) {
        // user clicks on the button to show daily view
        histogramMode = 0
        dataEntries = generateDataEntries()
        ATBarweekly.dataEntries = dataEntries
    }
    
}



