//
//  RootViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 24/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationBeforInbox"]; // navigation
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sideMenuController"]; //sidemenu
}


@end
