//
//  HomePageTest_Version2.swift
//  HomePageTest_Version2
//
//  Created by Dickson Chum on 2018-11-19.
//  Copyright © 2018 Daycar. All rights reserved.
//

import XCTest

class HomePageTest_Version2: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        app.otherElements.containing(.button, identifier:"Sign in").children(matching: .button)["Sign in"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Histogram"]/*[[".cells.staticTexts[\"Histogram\"]",".staticTexts[\"Histogram\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Histogram"].buttons["Home"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["the Coolest Event "]/*[[".cells.staticTexts[\"the Coolest Event \"]",".staticTexts[\"the Coolest Event \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Event Members"]/*[[".cells.staticTexts[\"Event Members\"]",".staticTexts[\"Event Members\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Participants"].buttons["the Coolest Event"].tap()
        app.navigationBars["the Coolest Event"].buttons["Home"].tap()
        app.buttons["EMERGENCY"].tap()
        app.alerts["Cannot Send Message"].buttons["OK"].tap()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
