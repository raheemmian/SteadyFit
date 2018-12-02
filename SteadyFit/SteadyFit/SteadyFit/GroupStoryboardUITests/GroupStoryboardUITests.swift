//
//  GroupStoryboardUITests.swift
//  GroupStoryboardUITests
//
//  Created by Raheem Mian on 2018-12-02.
//  Copyright © 2018 Daycar. All rights reserved.
//

import XCTest

class GroupStoryboardUITests: XCTestCase {

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

    func testAddPrivateGroup() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Groups"].tap()
        app.tables/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Groups\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Save"].tap()
        app.navigationBars["Create Private Group"].buttons["Groups"].tap()
        
    }
    
    func testGroupMembers(){
        let app = XCUIApplication()
        app.tabBars.buttons["Groups"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Public Group: Surrey, Moderate"]/*[[".cells.staticTexts[\"Public Group: Surrey, Moderate\"]",".staticTexts[\"Public Group: Surrey, Moderate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["More"]/*[[".cells.staticTexts[\"More\"]",".staticTexts[\"More\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Herbert"]/*[[".cells.staticTexts[\"Herbert\"]",".staticTexts[\"Herbert\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Profile"].buttons["More"].tap()
        app.navigationBars["More"].buttons["Public Group: Surrey, Moderate"].tap()
        app.navigationBars["Public Group: Surrey, Moderate"].buttons["Groups"].tap()

    }
    
    func testEventsGroupPage(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["Groups"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Public Group: Surrey, Moderate"]/*[[".cells.staticTexts[\"Public Group: Surrey, Moderate\"]",".staticTexts[\"Public Group: Surrey, Moderate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Tai Chi"]/*[[".cells.staticTexts[\"Tai Chi\"]",".staticTexts[\"Tai Chi\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Tai Chi"].buttons["Public Group: Surrey, Moderate"].tap()
        app.navigationBars["Public Group: Surrey, Moderate"].buttons["Groups"].tap()
        
    }
    func testAddEvent() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Groups"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Public Group: Surrey, Moderate"]/*[[".cells.staticTexts[\"Public Group: Surrey, Moderate\"]",".staticTexts[\"Public Group: Surrey, Moderate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Add Event"]/*[[".otherElements[\"Events\"].buttons[\"Add Event\"]",".buttons[\"Add Event\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Save"].tap()
        app.navigationBars["Add Event"].buttons["Public Group: Surrey, Moderate"].tap()
        app.navigationBars["Public Group: Surrey, Moderate"].buttons["Groups"].tap()

    }
    
    func testInvite(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["Groups"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Public Group: Surrey, Moderate"]/*[[".cells.staticTexts[\"Public Group: Surrey, Moderate\"]",".staticTexts[\"Public Group: Surrey, Moderate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Invite"]/*[[".otherElements[\"Members\"].buttons[\"Invite\"]",".buttons[\"Invite\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Invite"].buttons["Public Group: Surrey, Moderate"].tap()
        app.navigationBars["Public Group: Surrey, Moderate"].buttons["Groups"].tap()
        
    }
    

}
