//
//  UrlVerifyingViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 21/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "UrlVerifyingViewController.h"
#import "LoginViewController.h"
#import "UIColor+HexColors.h"

@interface UrlVerifyingViewController ()

@end

@implementation UrlVerifyingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _nextButtonOutlet.backgroundColor = [UIColor colorFromHexString:@"1287DE"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextButtonActionMethod:(id)sender {
    
    NSLog(@"Clcicked");
    LoginViewController *loginPage = [self.storyboard instantiateViewControllerWithIdentifier:@"loginID"];
    
    [loginPage setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
   [self presentViewController:loginPage animated:YES completion:nil];
    
}
@end
