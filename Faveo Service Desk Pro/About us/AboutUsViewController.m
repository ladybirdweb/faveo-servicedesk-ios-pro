//
//  AboutUsViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UIColor+HexColors.h"
#import "SWRevealViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:NSLocalizedString(@"About",nil)];
    
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);

    _websiteButtonOutlet.backgroundColor = [UIColor colorFromHexString:@"1287DE"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)websiteButtonAction:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://www.faveohelpdesk.com/"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
      //  [[UIApplication sharedApplication] openURL:url];
        //openURL:options:completionHandler:
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
             NSLog(@"Open %d",success);
            
        }];
    }else {
        
    }
}
@end
