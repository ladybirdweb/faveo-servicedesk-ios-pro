//
//  ClientDetailsViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ClientDetailsViewController
 
 @brief This class display detail information about client.
 
 @discussion Here you can see details of clients like Client Name, Contact Number, Profile Picture of a client and email if a client.
 
 */

@interface ClientDetailsViewController : UIViewController


/*!
 @property tableView
 
 @brief This is an instance of Table View.
 
 @discussion Table views are versatile user interface objects frequently found in iOS apps. A table view presents data in a scrollable list of multiple rows that may be divided into sections.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*!
 @property testingLAbel
 
 @brief This property in string format used for testing.
 */
@property (weak, nonatomic) IBOutlet UILabel *testingLAbel;

/*!
 @property clientNameLabel
 
 @brief This property in string format defines name of client.
 */
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;

/*!
 @property emailLabel
 
 @brief This property in string format defines email of client.
 */
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

/*!
 @property phoneLabel
 
 @brief This property in string format defines phone number of client.
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

/*!
 @property profileImageView
 
 @brief This property used for showing profile picture of user.
 
 @discussion Image views let you efficiently draw any image that can be specified using a
 UIImage object.
 For example, you can use the UIImageView class to display the contents of many standard image files, such as JPEG and PNG files. You can configure image views programmatically or in your storyboard file and change the images they display at runtime
 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

/*!
 @property mobileLabel
 
 @brief It is an label that will show mobile number of the client.
 */
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

/*!
 @property rolLabel
 
 @brief It is an label that will show tole of the client.
 */
@property (weak, nonatomic) IBOutlet UILabel *rolLabel;

// It is a string that represents Email of the user
@property(nonatomic,strong) NSString * emailID;

//It is state of ther user - Active, In-active, De-activated
@property(nonatomic,strong) NSString * isClientActive;

// It is a string that represents phone number of the user
@property(nonatomic,strong) NSString * phone;

// It is a string that represents name of the user
@property(nonatomic,strong) NSString * clientName;

// It is a string that represents id of the user
@property(nonatomic,strong) NSString * clientId;

// It is a string that represents imageURL of the user
@property (strong,nonatomic) NSString *imageURL;


/*!
 @method setUserProfileimage
 
 @brief This method used for setting an profile picture of user.
 
 @discussion Here we use url path of image where it is located so that using that url path it will show an profile picture of an user.
 
 @param imageUrl This contains an url.
 
 @code
 
 [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
 placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
 
 @endcode
 */
-(void)setUserProfileimage:(NSString*)imageUrl;


@end
