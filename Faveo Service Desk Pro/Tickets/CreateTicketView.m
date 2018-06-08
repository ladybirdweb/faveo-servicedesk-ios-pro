//
//  CreateTicketView.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "CreateTicketView.h"
#import "SWRevealViewController.h"

@interface CreateTicketView ()


@end

@implementation CreateTicketView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)countryClicked:(id)sender {
}

- (IBAction)priorityClicked:(id)sender {
}

- (IBAction)helptopicClicked:(id)sender {
}

- (IBAction)assigneeClicked:(id)sender {
}

- (IBAction)submitButtonClicked:(id)sender {
}
@end
