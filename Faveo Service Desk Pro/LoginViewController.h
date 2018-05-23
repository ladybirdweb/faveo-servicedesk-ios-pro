//
//  LoginViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 21/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *companyURLview;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet UILabel *servicdeskUrlLabel;
@property (weak, nonatomic) IBOutlet UITextField *urlTextfield;
@property (weak, nonatomic) IBOutlet UIButton *urlNextButton;
- (IBAction)urlNextButtonAction:(id)sender;



@property (weak, nonatomic) IBOutlet UIButton *loginButtonOutlet;

- (IBAction)loginButtonMethod:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;







@end
