//
//  DetailViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class DetailViewController
 
 @brief This class contains details of a ticket.
 
 @discussion This contain details of a ticket like Subject, Priority, HelpTopic, Name, email, source, ticket type and sue date.
 Here agent can edit things like subject, ticket priority,HelpTopic and Source.
 
 */
@interface DetailViewController : UITableViewController<UITextFieldDelegate>


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
@property (weak, nonatomic) IBOutlet UITextField *helptopicTextField;

/*!
 @property nameTextField
 
 @brief This property defines a textfield that shows name of a user.
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

/*!
 @property emailTextField
 
 @brief This property defines a textfield that shows email of a user.
 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

/*!
 @property sourceTextField
 
 @brief This property defines a textfield that shows sorce of ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *sourceTextField;

/*!
 @property typeTextField
 
 @brief This property defines a textfield that shows type of ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *ticketTypeTextField;

/*!
 @property assinTextField
 
 @brief This textField property used to show assignee/agent name
 */
@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;


/*!
 @property dueDateTextField
 
 @brief This property defines a textfield that shows due date of a ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;


/*!
 @property createdDateTextField
 
 @brief This property defines a textfield that shows date of ticket created.
 */
@property (weak, nonatomic) IBOutlet UITextField *createdTextField;


/*!
 @property lastResponseDateTextField
 
 @brief This property defines a textfield that shows date of last response of a tocket.
 */
@property (weak, nonatomic) IBOutlet UITextField *lastResponseTextField;


@end
