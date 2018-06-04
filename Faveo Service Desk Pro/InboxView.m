//
//  InboxView.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 31/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "InboxView.h"
#import "SWRevealViewController.h"

@interface InboxView ()

@end

@implementation InboxView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)testAction:(id)sender {
    
    NSLog(@"Clicked");
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
}
@end
