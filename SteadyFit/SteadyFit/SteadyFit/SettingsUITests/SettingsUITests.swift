//
//  SettingsUITests.swift
//  SettingsUITests
//
//  Created by Raheem Mian on 2018-12-02.
//  Copyright © 2018 Daycar. All rights reserved.
//

import XCTest

class SettingsUITests: XCTestCase {

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

    func testEditProfile() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Edit Profile"]/*[[".cells.staticTexts[\"Edit Profile\"]",".staticTexts[\"Edit Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Edit Profile"].buttons["Settings"].tap()
 
    }
    
    func testNotifications() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Toggle notfications for Events"]/*[[".cells.staticTexts[\"Toggle notfications for Events\"]",".staticTexts[\"Toggle notfications for Events\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Notification Settings"].buttons["Settings"].tap()
    }
    func testEmergency() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Edit the message being sent to emergency contact"]/*[[".cells.staticTexts[\"Edit the message being sent to emergency contact\"]",".staticTexts[\"Edit the message being sent to emergency contact\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element(boundBy: 0).tap()
        element.children(matching: .textField).element(boundBy: 1).tap()
        app.buttons["Save"].tap()
        
    }
    
    func testHelp(){
        XCUIApplication().tabBars.buttons["Settings"].tap()
        
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Help"]/*[[".cells.staticTexts[\"Help\"]",".staticTexts[\"Help\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Help"].buttons["Settings"].tap()
            
    }

}
