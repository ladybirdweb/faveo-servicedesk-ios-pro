//
//  TicketMergeView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 29/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class TicketMergeView
 
 @brief This class used to implement Ticket Merge feature.
 
 @discussion This clas contains some textFeilds and takes some input parameter before merging the tickets like subject, reason for merging and parent ticket and child ticket and after hiting anb merge button  this tickets will be merged( only if these 2 ticket are from same user else shows an error)
 
 */
@interface TicketMergeView : UITableViewController <UITableViewDataSource,UITableViewDelegate>


/*!
 @property newtitleTextview
 
 @brief This is an textView property
 
 @discussion Used to take some input data from the user for new title for merged ticket.
 */
@property (weak, nonatomic) IBOutlet UITextView *newtitleTextview;

/*!
 @property reasonTextView
 
 @brief This is an textView property
 
 @discussion Used to take some input data from the user for ticket merge reason.
 */
@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;

/*!
 @property parentTicketTextField
 
 @brief This is an textView property
 
 @discussion It represents the parent ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *parentTicketTextField;

/*!
 @property cancelLabel
 
 @brief This is an Label property
 
 @discussion Here this label is acts as a Button. I created label as a Button and performing an action.
 */
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;

/*!
 @property mergeLabel
 
 @brief This is an Label property
 
 @discussion Here this label is acts as a Button. I created label as a Button and performing an action.
 */
@property (weak, nonatomic) IBOutlet UILabel *mergeLabel;

/*!
 @property SelectParentTicket
 
 @brief This is button action method.
 
 @discussion It will open an picker view so user can able to select the value of parent ticket.
 */
- (IBAction)SelectParentTicket:(id)sender;


@end
