//
//  CreateTicketViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 07/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "CreateTicketViewController.h"
#import "SWRevealViewController.h"

@interface CreateTicketViewController ()

@end

@implementation CreateTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
