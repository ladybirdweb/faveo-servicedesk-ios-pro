//
//  LoginViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 21/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+HexColors.h"
#import "Utils.h"
#import "ViewController.h"

@interface LoginViewController ()
{
    Utils *utils;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     utils=[[Utils alloc]init];

    
    _servicdeskUrlLabel.textColor = [UIColor colorFromHexString:@"049BE5"];
    _urlNextButton.backgroundColor = [UIColor colorFromHexString:@"1287DE"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES];
    
    [utils viewSlideInFromRightToLeft:self.companyURLview];
    [self.loginView setHidden:YES];
    [self.companyURLview setHidden:NO];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self.urlTextfield becomeFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField == _urlTextfield)
    {
        //  [self URLValidationMethod];
        NSLog(@"Clicked on go");
    }
    
    return YES;
}


- (IBAction)urlNextButtonAction:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.companyURLview setHidden:YES];
        [self.loginView setHidden:NO];
        [self->utils viewSlideInFromRightToLeft:self.loginView];
       // [[AppDelegate sharedAppdelegate] hideProgressView];
        
    });
    
    
}

- (IBAction)loginButtonMethod:(id)sender {
    
    ViewController *inboxVC=[self.storyboard  instantiateViewControllerWithIdentifier:@"id"];
    [self.navigationController pushViewController:inboxVC animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    [[self navigationController] setNavigationBarHidden:NO];
}
@end
