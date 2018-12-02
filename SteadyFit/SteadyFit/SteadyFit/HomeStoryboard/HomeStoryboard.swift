//
//  HomeStoryboard.swift
//  HomeStoryboard
//
//  Created by Raheem Mian on 2018-12-02.
//  Copyright © 2018 Daycar. All rights reserved.
//

import XCTest

class HomeStoryboard: XCTestCase {

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

    func testCheckDifferentProgressResports() {
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Histogram"]/*[[".cells.staticTexts[\"Histogram\"]",".staticTexts[\"Histogram\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Daily Progress"].tap()
        app.buttons["Weekly Progress"].tap()
        app.buttons["Monthly Progress"].tap()
        app.navigationBars["Histogram"].buttons["Home"].tap()
    

    }
    
    

    func testEventOnProfile(){
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.tables.containing(.other, identifier:"Activity Tracker").element/*[[".tables.containing(.other, identifier:\"Events\").element",".tables.containing(.other, identifier:\"Activity Tracker\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["kickboxing"]/*[[".cells.staticTexts[\"kickboxing\"]",".staticTexts[\"kickboxing\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["kickboxing"].buttons["Home"].tap()
    }
    
    func testUploadImage() {
        let app = XCUIApplication()
        app.buttons["Upload Image"].tap()
        app.navigationBars["Photos"].buttons["Cancel"].tap()
    }
    
    func testRequests() {
        
        let app = XCUIApplication()
        app.buttons["Request"].tap()
        app.navigationBars["Pending Requests"].buttons["Home"].tap()

    }
    
    func testAddActivity(){
        
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Histogram"]/*[[".cells.staticTexts[\"Histogram\"]",".staticTexts[\"Histogram\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Active Minutes"].buttons["Add"].tap()
        app.buttons["Save"].tap()
        app.navigationBars["Add an Activity"].buttons["Histogram"].tap()
        app.navigationBars["Histogram"].buttons["Home"].tap()
 
    }
    

}
