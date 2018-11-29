//
//  AddRequester.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 11/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class AddRequester
 
 @brief This class used for registering the user.
 
 @discussion This class contains some textFields which is used to take values of the users and using these details he can able to register in the Faveo using Register API call.
 */
@interface AddRequester : UITableViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

/*!
 @property emailTextField
 
 @brief This is an textField property.
 
 @discussion This is used to accept the email of the user.
 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

/*!
 @property firstNameTextField
 
 @brief This is an textField property.
 
 @discussion This is used to accept the first name of the user.
 */
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;

/*!
 @property lastNameTextField
 
 @brief This is an textField property.
 
 @discussion This is used to accept the last name of the user.
 */
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

/*!
 @property mobileTextField
 
 @brief This is an textField property.
 
 @discussion This is used to accept the mobile of the user.
 */
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

/*!
 @property codeTextField
 
 @brief This is an textField property.
 
 @discussion This is used to accept the mobile code(country) of the user.
 */
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

/*!
 @property submitButtonOutlet
 
 @brief This is an Button property.
 
 @discussion After clicking this it validate the data entered in the textField and then after verifying resgister API is called.
 */
@property (weak, nonatomic) IBOutlet UIButton *submitButtonOutlet;



/*!
 @property headerTitleView
 
 @brief This is an View property.
 
 @discussion This is used to show na view at the header of the view.
 */
@property (weak, nonatomic) IBOutlet UIView *headerTitleView;


/*!
 @property countryArray
 
 @brief This is an Array property.
 
 @discussion This is used show collection of country code used along with mobile number.
 */
@property (nonatomic, strong) NSArray * countryArray;

/*!
 @property codeArray
 
 @brief This is an Array property.
 
 @discussion This is used show collection of country code used along with mobile number.
 */
@property (nonatomic, strong) NSArray * codeArray;

/*!
 @property countryDic
 
 @brief This is an Dictionary property.
 
 @discussion This is used to store some values of country names along with country codes.
 */
@property (nonatomic, strong) NSDictionary * countryDic;

/*!
 @method countryCodeClicked
 
 @brief This will gives List of all country codes.
 
 @code
 
 - (IBAction)countryCodeClicked:(id)sender;
 
 @endocde
 */
- (IBAction)countryClicked:(id)sender;


/*!
 @method submitButtonAction
 
 @brief This is an button action. After clicling on submit button it will register the user and come backs to the create ticket page.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 - (IBAction)submitButtonAction:(id)sender;
 
 @endcode
 */
- (IBAction)submitButtonAction:(id)sender;


@end
