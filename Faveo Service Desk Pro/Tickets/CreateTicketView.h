//
//  CreateTicketView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class CreateTicketView
 
 @brief This class contain Ticket  create process.
 
 @discussion Here  we can create a ticket by filling some necessary information. After filling valid infomation, ticket will be crated.
 */
@interface CreateTicketView : UITableViewController

/*!
 @property sidebarButton
 
 @brief This bar button property used for showing and hiding purpose.
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

/*!
 @property emailTextView
 
 @brief It is textView that allows a user to enter his email address.
 */
@property (weak, nonatomic) IBOutlet UITextView *emailTextView;

/*!
 @property addRequesterImage
 
 @brief This is an property of type image used show an image Icon.
 
 @discussion This is used to shown an image for register button. After clicking on this button it will navigate to the register user page.
 */
@property (weak, nonatomic) IBOutlet UIImageView *addRequesterImage;

/*!
 @property ccTextField
 
 @brief This is an textField property.
 
 @discussion This is used to add cc (user mail) to the ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *ccTextField;

/*!
 @property firstNameTextView
 
 @brief It is textView property that allows a user to enter his first name.
 */
@property (weak, nonatomic) IBOutlet UITextView *firstNameTextView;

/*!
 @property lastNameTextView
 
 @brief It is textView property that allows a user to enter his last name.
 */
@property (weak, nonatomic) IBOutlet UITextView *lastNameTextView;

/*!
 @property codeTextField
 
 @brief It is textField property that allows a user to enter/select country code for mobile using picker view.
 */
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

/*!
 @property mobileTextView
 
 @brief It is textView property that allows a user to enter mobile number.
 */
@property (weak, nonatomic) IBOutlet UITextView *mobileTextView;

/*!
 @property subjectTextView
 
 @brief It is textView property that allows a user to enter ticket subject.
 */
@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

/*!
 @property messageTextView
 
 @brief It is textView property that allows a user to enter message for the ticket.
 */
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

/*!
 @property helptopicTextField
 
 @brief It is textField property that allows a user to select helptopic using pickerView
 */
@property (weak, nonatomic) IBOutlet UITextField *helptopicTextField;

/*!
 @property assigneeTextField
 
 @brief It is textField property that allows a user to select assignee/agent using pickerView
 */
@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;

/*!
 @property priorityTextField
 
 @brief It is textField property that allows a user to select ticket priorities using pickerView
 */
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

/*!
 @property submitButtonOutlet
 
 @brief This is a button property.
 
 @discussion When you tap a button, or select a button that has focus, the button performs any actions attached to it. You communicate the purpose of a button using a text label, an image, or both.
 */
@property (weak, nonatomic) IBOutlet UIButton *submitButtonOutlet;


/*!
 @method countryCodeClicked
 
 @brief This will gives List of all country codes.
 
 @code
 
 - (IBAction)countryCodeClicked:(id)sender;
 
 @endocde
 */
- (IBAction)countryCodeClicked:(id)sender;

/*!
 @method priorityClicked
 
 @brief This will gives List of Ticket Priorities.
 
 @discussion After clicking this button whatever we done any chnages in ticket, it will save and updated in ticket details.
 
 @code
 
 - (IBAction)priorityClicked:(id)sender;
 
 @endocde
 */
- (IBAction)priorityClicked:(id)sender;

/*!
 @method helpTopicClicked
 
 @brief It will gives List of Help Topics.
 
 @discussion After clicking this button it will show list of help topics.
 
 The help topics can be Support Query, Sales Query or Operational Query.
 
 @code
 
 - (IBAction)helpTopicClicked:(id)sender;
 
 @endcode
 
 */
- (IBAction)helptopicClicked:(id)sender;

/*!
 @method assigneeClicked
 
 @brief This will gives List of all agent list.
 
 @code
 
 - (IBAction)assigneeClicked:(id)sender;
 
 @endocde
 */
- (IBAction)assigneeClicked:(id)sender;

/*!
 @method submitButtonClicked
 
 @brief This is an button that perform an action.
 
 @discussion  After cicking this submit button, the data enetered in textfiled while ticket creation will be saved.
 
 @code
 
 - (IBAction)submitButtonClicked:(id)sender;
 
 @endcode
 
 */
- (IBAction)submitButtonClicked:(id)sender;


/*!
 @property countryDic
 
 @brief This is Dictionary that represents list of Country Names.
 
 @discussion An object representing a static collection of key-value pairs, for use instead ofa Dictionary constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSDictionary * countryDic;

/*!
 @property staffArray
 
 @brief This is array that represents list of Agent Lists.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * staffArray;

/*!
 @property codeArray
 
 @brief This is array that represents list of Country Codes.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSArray * codeArray;

/*!
 @property countryArray
 
 @brief This is array that represents list of Country names.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSArray * countryArray;

/*!
 @property priorityArray
 
 @brief This is array that represents list of Priorities.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSArray * priorityArray;

/*!
 @property helptopicsArray
 
 @brief This is array that represents list of Helptopics.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSArray * helptopicsArray;


/*!
 @property fileImage
 
 @brief This is an Image Property.
 
 @discussion This is used to show an icon (attachment type) of selected attachment.
 */
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;

/*!
 @property fileName123
 
 @brief This is an Label Property.
 
 @discussion This is used to show file name of the selected attachment.
 */
@property (weak, nonatomic) IBOutlet UILabel *fileName123;

/*!
 @property fileSize123
 
 @brief This is an Label Property.
 
 @discussion This is used to show file size of the selected attachment.
 */
@property (weak, nonatomic) IBOutlet UILabel *fileSize123;



@end
