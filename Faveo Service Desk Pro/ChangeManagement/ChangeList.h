//
//  ChangeList.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/12/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ProblemList
 
 @brief This class used to all list of Probelms.
 
 @discussion This class uses tableView to show all list of problems with basic details.
 */
@interface ChangeList : UIViewController

/*!
 @property tableView
 
 @brief This propert is an instance of a table view.
 
 @discussion Table views are versatile user interface objects frequently found in iOS apps. A table view presents data in a scrollable list of multiple rows that may be divided into sections.
 */
@property (weak, nonatomic) IBOutlet UITableView *sampleTableview;

//side menu outlet
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

/*!
 @property page
 
 @brief This is an integer property.
 
 @discussion It used to represent the current page.
 */
@property (nonatomic) NSInteger page;



@end

