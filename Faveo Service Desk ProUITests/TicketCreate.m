//
//  TicketCreate.m
//  Faveo Service Desk ProUITests
//
//  Created by Mallikarjun on 10/02/19.
//  Copyright © 2019 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TicketCreate : XCTestCase

@end

@implementation TicketCreate

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCreteTicket {
   
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"Inbox"].buttons[@"Item"] tap];
    
    XCUIElementQuery *tablesQuery2 = app.tables;
    XCUIElementQuery *tablesQuery = tablesQuery2;
    [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"Create Ticket"]/*[[".cells.staticTexts[@\"Create Ticket\"]",".staticTexts[@\"Create Ticket\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    XCUIElement *textView = [[tablesQuery2.cells containingType:XCUIElementTypeStaticText identifier:@"Requester*"] childrenMatchingType:XCUIElementTypeTextView].element;
    [textView tap];
    XCTAssertTrue(textView.exists);
    [textView typeText:@"demoemail@abc.com"];
    
    XCUIElement *textView2 = [[tablesQuery2.cells containingType:XCUIElementTypeStaticText identifier:@"First Name*"] childrenMatchingType:XCUIElementTypeTextView].element;
    [textView2 tap];
    XCTAssertTrue(textView2.exists);
    [textView2 typeText:@"Jayesh"];
    
    XCUIElement *textView3 = [[tablesQuery2.cells containingType:XCUIElementTypeStaticText identifier:@"Last Name"] childrenMatchingType:XCUIElementTypeTextView].element;
    [textView3 tap];
    XCTAssertTrue(textView3.exists);
    [textView3 typeText:@"Patil"];
    
    //Selecting Country Code
    /*@START_MENU_TOKEN@*/[tablesQuery.textFields[@"Ex: +91"] pressForDuration:1.8];/*[["tablesQuery",".cells.textFields[@\"Ex: +91\"]","["," tap];"," pressForDuration:1.8];",".textFields[@\"Ex: +91\"]"],[[[-1,0,1]],[[-1,5,2],[-1,1,2]],[[2,4],[2,3]]],[0,0,0]]@END_MENU_TOKEN@*/
    
    XCUIElement *doneButton = app.toolbars[@"Toolbar"].buttons[@"Done"];
    [doneButton tap];
    
    XCUIElement *textView4 = [/*@START_MENU_TOKEN@*/[tablesQuery2.cells containingType:XCUIElementTypeStaticText identifier:@"Code"]/*[["tablesQuery2","[",".cells containingType:XCUIElementTypeStaticText identifier:@\"Mobile\"]",".cells containingType:XCUIElementTypeStaticText identifier:@\"Code\"]"],[[[-1,0,1]],[[1,3],[1,2]]],[0,0]]@END_MENU_TOKEN@*/ childrenMatchingType:XCUIElementTypeTextView].element;
    [textView4 tap];
    
    XCUIElement *mobileNumber = [[tablesQuery2.cells containingType:XCUIElementTypeStaticText identifier:@"Mobile"] childrenMatchingType:XCUIElementTypeTextView].element;
    [mobileNumber tap];
    XCTAssertTrue(mobileNumber.exists);
    [mobileNumber typeText:@"9158696984"];
    
    XCUIElement *textView5 = [[tablesQuery2.cells containingType:XCUIElementTypeStaticText identifier:@"Subject*"] childrenMatchingType:XCUIElementTypeTextView].element;
    [textView5 tap];
    XCTAssertTrue(textView5.exists);
    [textView5 typeText:@"This is sample subject for this ticket."];
    
    //[app.alerts[@"Faveo Helpdesk"].buttons[@"OK"] tap];
    // [textView5 tap];
    
    XCUIElement *textView6 = [[tablesQuery2.cells containingType:XCUIElementTypeStaticText identifier:@"Message*"] childrenMatchingType:XCUIElementTypeTextView].element;
    [textView6 tap];
    XCTAssertTrue(textView6.exists);
    [textView6 typeText:@"This is sample message for this ticket."];
    
    
    /*@START_MENU_TOKEN@*/[tablesQuery.textFields[@"Select Priority"] pressForDuration:1.2];/*[["tablesQuery",".cells.textFields[@\"Select Priority\"]","["," tap];"," pressForDuration:1.2];",".textFields[@\"Select Priority\"]"],[[[-1,0,1]],[[-1,5,2],[-1,1,2]],[[2,4],[2,3]]],[0,0,0]]@END_MENU_TOKEN@*/
    [doneButton tap];
    
    /*@START_MENU_TOKEN@*/[tablesQuery.textFields[@"Select Helptopic"] pressForDuration:1.2];/*[["tablesQuery",".cells.textFields[@\"Select Helptopic\"]","["," tap];"," pressForDuration:1.2];",".textFields[@\"Select Helptopic\"]"],[[[-1,0,1]],[[-1,5,2],[-1,1,2]],[[2,4],[2,3]]],[0,0,0]]@END_MENU_TOKEN@*/
    [doneButton tap];
    /*@START_MENU_TOKEN@*/[tablesQuery.textFields[@"Select Assignee"] pressForDuration:1.1];/*[["tablesQuery",".cells.textFields[@\"Select Assignee\"]","["," tap];"," pressForDuration:1.1];",".textFields[@\"Select Assignee\"]"],[[[-1,0,1]],[[-1,5,2],[-1,1,2]],[[2,4],[2,3]]],[0,0,0]]@END_MENU_TOKEN@*/
    /*@START_MENU_TOKEN@*/[app.pickerWheels[@"Select Assignee"] pressForDuration:1.4];/*[["app",".pickers.pickerWheels[@\"Select Assignee\"]","["," tap];"," pressForDuration:1.4];",".pickerWheels[@\"Select Assignee\"]"],[[[-1,0,1]],[[-1,5,2],[-1,1,2]],[[2,4],[2,3]]],[0,0,0]]@END_MENU_TOKEN@*/
    [doneButton tap];
    
    [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"HelpTopics*"]/*[[".cells.staticTexts[@\"HelpTopics*\"]",".staticTexts[@\"HelpTopics*\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ swipeUp];
    
    [tablesQuery/*@START_MENU_TOKEN@*/.buttons[@"Submit"]/*[[".cells.buttons[@\"Submit\"]",".buttons[@\"Submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
}

@end
