//
//  ViewController1.m
//  ExpandableList
//
//  Created by Mallikarjun on 30/05/18.
//  Copyright © 2018 Tasvir H Rohila. All rights reserved.
//

#import "ViewController1.h"
#import "InboxViewController.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    
    InboxViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"inboxID"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
