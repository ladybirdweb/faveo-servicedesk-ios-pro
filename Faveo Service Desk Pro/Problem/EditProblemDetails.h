//
//  EditProblemDetails.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class EditProblemDetails
 
 @brief This class used to edit/update/modify more details of the problem.
 
 @discussion It contains detailed informations like proble subject, problem description, from(owner), problem status, priority of the problem, location, source of the problems, department, impact of the problem and assets list assocciated with the problem.
 */
@interface EditProblemDetails : UITableViewController

/*!
 @property problemSubject
 
 @brief This is an textView property
 
 @discussion Used to show an existing subject data of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

/*!
 @property problemDescription
 
 @brief This is an textView property
 
 @discussion Used to show an existing description data of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

/*!
 @property fromTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing problem creator data of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;

/*!
 @property impactTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing impact value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *impactTextField;

/*!
 @property statusTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing status value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

/*!
 @property priorityTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing priority value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

/*!
 @property departmentTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing department value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;

/*!
 @property locationTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing location value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

/*!
 @property assigneeTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing assignee/agent name value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;


/*!
 @property assetsTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing asset value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *assetsTextField;


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


/*!
 @method submitButtonClicked
 
 @brief It is button action method
 
 @discussion It will call update problem API by taking all values updated/selected/modifield and given by the agent/admin.
 
 @code
 
 - (IBAction)submitButtonClicked:(id)sender;
 
 @endcode
 */
- (IBAction)submitButtonClicked:(id)sender;



@end
