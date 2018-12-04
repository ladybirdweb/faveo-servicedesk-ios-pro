//
//  InboxTicketsViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class InboxTickets
 
 @brief This class contains list of oepn Tickets
 
 @discussion This class uses a table view and it gives a list of tickets. Every ticket contain ticket number, subject, profile picture and contact number of client. After clicking a particular ticket it will moves to conversation page. Here we will see conversation between Agent and client.
 */

@interface InboxTickets : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    BOOL searching;
}


//side menu outlet
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


/*!
 @property tableView
 
 @brief This propert is an instance of a table view.
 
 @discussion Table views are versatile user interface objects frequently found in iOS apps. A table view presents data in a scrollable list of multiple rows that may be divided into sections.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


/*!
 @property page
 
 @brief This is an integer property.
 
 @discussion It used to represent the current page.
 */
@property (nonatomic) NSInteger page;

/*!
 @property sampleDataArray
 
 @brief This is an Array property.
 
 @discussion This array represents that it contains some sample data used for internal purpose.
 */
@property (strong, nonatomic) NSMutableArray *sampleDataArray;

/*!
 @property filteredSampleDataArray
 
 @brief This is an Array property.
 
 @discussion It used to store filtered data.
 */
@property (strong, nonatomic) NSMutableArray *filteredSampleDataArray;

/*!
 @method hideTableViewEditMode
 
 @brief This is Button method
 
 @discussion It used to hide the tableView editing method.
 
 @code
 
 - (IBAction)btnLogin:(id)sender;
 
 @endcode
 
 */
-(void)hideTableViewEditMode;

//-(void)showMessageForLogout:(NSString*)message sendViewController:(UIViewController *)viewController;

@end
