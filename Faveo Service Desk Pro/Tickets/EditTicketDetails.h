//
//  EditTicketDetails.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class EditTicketDetails
 
 @brief This class used for edit ticket.
 
 @discussion By changing ticket properties like subject, status, type and assignee of the ticket user can able to update the ticket details only if agent/admin having permission of edit ticket else it will show an warning like you do not permission.
 
 */
@interface EditTicketDetails : UITableViewController

/*!
 @property messageTextView
 
 @brief This textView property used to show ticket message
 */
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

/*!
 @property priorityTextField
 
 @brief This property defines a textfield that shows ticket priority.
 */
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

/*!
 @property helpTopicTextField
 
 @brief This property defines a textfield that shows Help Topic name.
 */
@property (weak, nonatomic) IBOutlet UITextField *helptopicsTextField;


/*!
 @property sourceTextField
 
 @brief This property defines a textfield that shows sorce of ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *sourceTextField;

/*!
 @property typeTextField
 
 @brief This property defines a textfield that shows type of ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

/*!
 @property assinTextField
 
 @brief This textField property used to show assignee/agent name
 */
@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;

/*!
 @property selectedIndex
 
 @brief This integer property used to represent index of selected picker value.
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/*!
 @property saveButton
 
 @brief This is an button property.
 
 */
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

/*!
 @method priorityClicked
 
 @brief This will gives List of all ticket priority list.
 
 @code
 
 - (IBAction)priorityClicked:(id)sender;
 
 @endocde
 */
- (IBAction)priorityClicked:(id)sender;

/*!
 @method helptopicClicked
 
 @brief This will gives List of all helptopic list.
 
 @code
 
 - (IBAction)helptopicClicked:(id)sender;
 
 @endocde
 */
- (IBAction)helptopicClicked:(id)sender;

/*!
 @method sourceClicked
 
 @brief This will gives List of all ticket source list.
 
 @code
 
 - (IBAction)sourceClicked:(id)sender;
 
 @endocde
 */
- (IBAction)sourceClicked:(id)sender;

/*!
 @method typeClicked
 
 @brief This will gives List of all ticket types list.
 
 @code
 
 - (IBAction)typeClicked:(id)sender;
 
 @endocde
 */
- (IBAction)typeClicked:(id)sender;

/*!
 @method assignClicked
 
 @brief This will gives List of all agent list.
 
 @code
 
 - (IBAction)assignClicked:(id)sender;
 
 @endocde
 */
- (IBAction)assigneeClicked:(id)sender;

/*!
 @method saveButtonAction
 
 @brief It will save the ticket details modified by user.
 
 @code
 
 - (IBAction)saveButtonAction:(id)sender;
 
 @endocde
 */
- (IBAction)saveButtonAction:(id)sender;


/*!
 @property helptopicsArray
 
 @brief This an Array property used to store all the helptopics names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * helptopicsArray;

/*!
 @property deptArray
 
 @brief This an Array property used to store all the department names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * deptArray;

/*!
 @property priorityArray
 
 @brief This an Array property used to store all the ticket priority names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * priorityArray;

/*!
 @property sourceArray
 
 @brief This an Array property used to store all the ticket source names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * sourceArray;

/*!
 @property typeArray
 
 @brief This an Array property used to store all the ticket type names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * typeArray;



@end
