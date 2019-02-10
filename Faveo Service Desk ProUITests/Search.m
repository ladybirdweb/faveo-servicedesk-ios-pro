//
//  Search.m
//  Faveo Service Desk ProUITests
//
//  Created by Mallikarjun on 08/02/19.
//  Copyright © 2019 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Search : XCTestCase

@end

@implementation Search

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

- (void)testTicketSearch {
   
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *searchNavigationBarButton = app.navigationBars[@"Inbox"].buttons[@"search1"];

    // Validate Search button present on Naviagtion Bar
    XCTAssertTrue(searchNavigationBarButton.exists);
    // Clicked on Search Button
    [searchNavigationBarButton tap];
    
    
    XCUIElement *searchTextField = app.textFields[@"search here..."];
    
    // Validate Search button present on  Search Page
    XCTAssertTrue(searchTextField.exists);
    // Clicked on search textfield
    [searchTextField tap];
    
    //type data in text field
    [searchTextField typeText:@"test data"];
    
    // Clicked on tickets option on segemenet control
    [app/*@START_MENU_TOKEN@*/.buttons[@"Ticket"]/*[[".segmentedControls.buttons[@\"Ticket\"]",".buttons[@\"Ticket\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
}



@end
