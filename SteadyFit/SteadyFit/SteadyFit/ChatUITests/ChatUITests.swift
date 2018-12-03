//
//  ChatUITests.swift
//  ChatUITests
//
//  Created by Raheem Mian on 2018-12-02.
//  Copyright © 2018 Daycar. All rights reserved.
//

import XCTest

class ChatUITests: XCTestCase {

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

    func testPriavteChats() {
        let app = XCUIApplication()
        app.tabBars.buttons["Chats"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Yimin"]/*[[".cells.staticTexts[\"Yimin\"]",".staticTexts[\"Yimin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Yimin"].buttons["Chat"].tap()

    }
    func testGroupChats(){
        let app = XCUIApplication()
        app.tabBars.buttons["Chats"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Public Group: Surrey, Moderate"]/*[[".cells.staticTexts[\"Public Group: Surrey, Moderate\"]",".staticTexts[\"Public Group: Surrey, Moderate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Public Group: Surrey, Moderate"].buttons["Chat"].tap()
        
    }

}
