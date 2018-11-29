//
//  TrashTickets.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class TrashTickets
 
 @brief This class contains list of Trash Tickets.
 
 @discussion This class contains a table view and it gives a list of trashed tickets. After clicking a particular ticket we will moves to conversation page. Here we will see conversation between Agent and client.
 */

@interface TrashTickets : UIViewController

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
 
 @brief This is an integer property
 
 @discussion It used to represent the page number.
 */
@property (nonatomic) NSInteger page;

@end



