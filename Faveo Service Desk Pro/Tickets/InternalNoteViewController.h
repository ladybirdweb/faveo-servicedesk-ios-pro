//
//  InternalNoteViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 09/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class InternalNoteViewController
 
 @brief This class used for adding internal note to the ticket.
 
 @discussion This note is added for internal message which is visible to only agents/admins not to user.
 
 */
@interface InternalNoteViewController : UITableViewController

/*!
 @property tableview
 
 @brief This is tableView property.
 
 @discussion This property used for some internal purpose while showing/adding into tableView and tableViewCells
 */
@property (strong, nonatomic) IBOutlet UITableView *tableview;

/*!
 @property noteTextView
 
 @brief This is textView property.
 
 @discussion This property used to take input data (internal message/content) from the agent/admin.
 */
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;


@property (weak, nonatomic) IBOutlet UIButton *submitButtonOutlet;


/*!
 @property noteContentLabel
 
 @brief This is label property used to show some label.
 */
@property (weak, nonatomic) IBOutlet UILabel *noteContentLabel;

/*!
 @method submitButtonAction
 
 @brief This is an button action method.
 
 @discussion After clicking this button add internal note API called.
 
 @code
 
 - (IBAction)submitButtonAction:(id)sender;
 
 @endcode
 */
- (IBAction)submitButtonAction:(id)sender;


@end
