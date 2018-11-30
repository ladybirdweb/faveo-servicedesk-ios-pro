//
//  CreateProblem.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

/*!
 @class CreateProblem
 
 @brief This class used for creating a new problem.
 
 @discussion Here  we can problem a ticket by filling some necessary information. After filling valid infomation, ticket will be created.
 */
@interface CreateProblem : UITableViewController

//side menu outlet
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


/*!
 @property fromArray
 
 @brief This is array that represents list of owner/creater of the problem with basic details.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * fromArray;


/*!
 @property departmentArray
 
 @brief This is array that represents list of departments present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * departmentArray;

/*!
 @property impactArray
 
 @brief This is array that represents list of problem impact types present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * impactArray;

/*!
 @property statusArray
 
 @brief This is array that represents list of ticket types present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * statusArray;

/*!
 @property locationArray
 
 @brief This is array that represents list of different locations present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * locationArray;

/*!
 @property priorityArray
 
 @brief This is array that represents list of different priority types present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * priorityArray;

/*!
 @property assignedArray
 
 @brief This is array that represents list of assignee/agent names which are present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * assignedArray;

/*!
 @property assetArray
 
 @brief This is array that represents list of asset names with its id which are present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * assetArray;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;


/*!
 @method fromTextFieldClicked
 
 @brief It is button action method
 
 @discussion After clicking it open an picker view so user can able to select "from" value from the picker view
 
 @code
 
 - (IBAction)fromTextFieldClicked:(id)sender;
 
 @endcode
 */
- (IBAction)fromTextFieldClicked:(id)sender;

/*!
 @method impactTextFieldClicked
 
 @brief It is button action method
 
 @discussion After clicking it open an picker view so user can able to select "impact" value from the picker view
 
 @code
 
 - (IBAction)impactTextFieldClicked:(id)sender;
 
 @endcode
 */
- (IBAction)impactTextFieldClicked:(id)sender;

/*!
 @method statusTextFieldClicked
 
 @brief It is button action method
 
 @discussion After clicking it open an picker view so user can able to select "status" value from the picker view
 
 @code
 
 - (IBAction)statusTextFieldClicked:(id)sender;
 
 @endcode
 */
- (IBAction)statusTextFieldClicked:(id)sender;

/*!
 @method priorityTextFieldClicked
 
 @brief It is button action method
 
 @discussion After clicking it open an picker view so user can able to select "priority" value from the picker view
 
 @code
 
 - (IBAction)priorityTextFieldClicked:(id)sender;
 
 @endcode
 */
- (IBAction)priorityTextFieldClicked:(id)sender;

/*!
 @method departmentTextFieldClicked
 
 @brief It is button action method
 
 @discussion After clicking it open an picker view so user can able to select "department" value from the picker view
 
 @code
 
 - (IBAction)departmentTextFieldClicked:(id)sender;
 
 @endcode
 */
- (IBAction)departmentTextFieldClicked:(id)sender;


/*!
 @method locationTextFieldClicked
 
 @brief It is button action method
 
 @discussion After clicking it open an picker view so user can able to select "location" value from the picker view
 
 @code
 
 - (IBAction)locationTextFieldClicked:(id)sender;
 
 @endcode
 */
- (IBAction)locationTextFieldClicked:(id)sender;


/*!
 @method assigneeTextFieldClicked
 
 @brief It is button action method
 
 @discussion After clicking it open an picker view so user can able to select "agent names" value from the picker view
 
 @code
 
 - (IBAction)assigneeTextFieldClicked:(id)sender;
 
 @endcode
 */
- (IBAction)assigneeTextFieldClicked:(id)sender;

/*!
 @method assetsTextFieldClicked
 
 @brief It is button action method
 
 @discussion After clicking it open an picker view so user can able to select "asset names" value from the picker view
 
 @code
 
 - (IBAction)assetsTextFieldClicked:(id)sender;
 
 @endcode
 */
- (IBAction)assetsTextFieldClicked:(id)sender;


/*!
 @method submitButtonClicked
 
 @brief It is button action method
 
 @discussion It will call create problem API by taking all values selected and given by the agent/admin.
 
 @code
 
 - (IBAction)submitButtonClicked:(id)sender;
 
 @endcode
 */
- (IBAction)submitButtonClicked:(id)sender;

/*!
 @property subjectTextView
 
 @brief This textView property used to accept/take subject of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

/*!
 @property descriptionTextView
 
 @brief This textView property used to accept/take description of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

/*!
 @property fromTextField
 
 @brief This textField property used to accept/take and show from/owner value
 */
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;

/*!
 @property impactTextField
 
 @brief This textField property used to accept/take and show impact value.
 */
@property (weak, nonatomic) IBOutlet UITextField *impactTextField;

/*!
 @property statusTextField
 
 @brief This textField property used to accept/take and show problem status value.
 */
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

/*!
 @property priorityTextField
 
 @brief This textField property used to accept/take and show priority value.
 */
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

/*!
 @property departmentTextField
 
 @brief This textField property used to accept/take and show department value.
 */
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;

/*!
 @property locationTextField
 
 @brief This textField property used to accept/take and show location value.
 */
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

/*!
 @property assigneeTextField
 
 @brief This textField property used to accept/take and show assignne/agent value.
 */
@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;

/*!
 @property assetTextField
 
 @brief This textField property used to accept/take and show asset value.
 */
@property (weak, nonatomic) IBOutlet UITextField *assetTextField;


@end
