//
//  ClientEditDetailsView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ClientEditDetailsView
 
 @brief This class used for edit user profile/data.
 
 @discussion This class contains number of textFields like name, email, username...etc so you can able to modify/update its contents.
 
 */
@interface ClientEditDetailsView : UITableViewController


/*!
 @property userNameTextField
 
 @brief This is an textField property
 
 @discussion This property is used to show user name or take new username from the user.
 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

/*!
 @property firstNameTextField
 
 @brief This is an textField property
 
 @discussion This property is used to show first name or take new first from the user.
 */
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;

/*!
 @property lastNameTextField
 
 @brief This is an textField property
 
 @discussion This property is used to show last name or take new last name from the user.
 */
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

/*!
 @property emailTextField
 
 @brief This is an textField property
 
 @discussion This property is used to show user email id or take new email id from the user.
 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

/*!
 @property submitButton
 
 @brief This button property used to perform some actions.
 */
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


/*!
 @method submitButtonAction
 
 @brief This is an button action. After clicking button it will update the user details.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 - (IBAction)submitButtonAction:(id)sender;
 
 @endcode
 
 */
- (IBAction)submitButtonAction:(id)sender;



@end
