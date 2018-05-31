//
//  InboxViewController.m
//  ExpandableList
//
//  Created by Mallikarjun on 31/05/18.
//  Copyright © 2018 Tasvir H Rohila. All rights reserved.
//

#import "InboxViewController.h"
#import "SWRevealViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

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



@end
