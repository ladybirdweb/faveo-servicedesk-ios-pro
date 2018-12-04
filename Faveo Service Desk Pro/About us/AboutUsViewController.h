//
//  AboutUsViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class AboutUsViewController
 
 @brief This class display information about Company.
 
 @discussion This class contain a view where It will show information about Faveo Helpdesk.
 
 */
@interface AboutUsViewController : UIViewController

/*!
 @property textview
 
 @brief This is textView property.
 
 @discussion This textView contains a company details.
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewOutlet;

/*!
 @property websiteButtonOutlet
 
 @brief This is simple button property.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 */
@property (weak, nonatomic) IBOutlet UIButton *websiteButtonOutlet;

// it is instance of barButtonItem used for enabling sidemenu
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

/*!
 @method websiteButtonAction
 
 @brief This in an Button.
 @discussion After clicking this button acton is performed i.e It will goto http://www.faveohelpdesk.com url. This link contains website of Faveo Helpdesk. Here we see details information of Faveo Helpdesk.
 
 @code
 
 - (IBAction)websiteButtonAction:(id)sender;
 
 @endocde
 
 @warning If internet is available then it will rediect to that url.
 */
- (IBAction)websiteButtonAction:(id)sender;


@end
