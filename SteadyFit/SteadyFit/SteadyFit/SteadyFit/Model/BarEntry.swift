//
//  BarEntry.swift
//  SteadyFit
//
//  Created by Akshay Kumar on 11/17/18.
//  Copyright © 2018 Daycar. All rights reserved.
//
//This is the structure for the Bar graph's co-ordinates, size and their values.
//This functionality was implemented with the help of Minh Nguyen's tutorial at medium along with
//modifications to suit our implemention, the tutorial can be found at:
//https://medium.com/@leonardnguyen/build-your-own-chart-in-ios-part-1-bar-chart-e1b7f4789d70

import Foundation
import UIKit

struct BarEntry {
    let color: UIColor
    let height: Float
    let textValue: String
    let title: String
}

