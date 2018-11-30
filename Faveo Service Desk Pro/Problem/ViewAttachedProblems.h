//
//  ViewAttachedProblems.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 26/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ViewAttachedProblems
 
 @brief This class used to view attached problem to the ticket.
 
 @discussion It represents a tableView which will include attached problem with its basic details. It ticket details view agent/admin can able to see/check attached problem associated with the ticket. He can view the details also after clicking on that problem or else he can detach the problem from the ticket.
 */
@interface ViewAttachedProblems : UIViewController<UITableViewDataSource,UITableViewDelegate>

/*!
 @property tableview
 
 @brief This propert is an instance of a table view.
 
 @discussion Table views are versatile user interface objects frequently found in iOS apps. A table view presents data in a scrollable list of multiple rows that may be divided into sections.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableview;

/*!
 @property viewButtonOutlet
 
 @brief This is an label property
 
 @discussion It used to represent/show an label called 'View' and it acts as button, after clicking on this label it will navigate to the problem details view.
 */
@property (weak, nonatomic) IBOutlet UIButton *viewButtonOutlet;

/*!
 @property detachButtonOutlet
 
 @brief This is an label property
 
 @discussion It used to represent/show an label called 'Detach' and it acts as button, after clicking this label it will detach the problem from the ticket.
 */
@property (weak, nonatomic) IBOutlet UIButton *detachButtonOutlet;

/*!
 @method viewButtonClicked
 
 @brief This is an button action method. After clicking view label, after clicking this label it will detach the problem from the ticket.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 - (IBAction)viewButtonClicked:(id)sender;
 
 @endcode
 */
- (IBAction)viewButtonClicked:(id)sender;

/*!
 @method detachButtonClicked
 
 @brief This is an button action method. After clicking view label, after clicking this label it will detach the problem from the ticket.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 - (IBAction)detachButtonClicked:(id)sender;
 
 @endcode
 */
- (IBAction)detachButtonClicked:(id)sender;



@end
