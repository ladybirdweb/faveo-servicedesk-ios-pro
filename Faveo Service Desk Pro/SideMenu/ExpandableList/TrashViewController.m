//
//  TrashViewController.m
//  ExpandableList
//
//  Created by Mallikarjun on 31/05/18.
//  Copyright © 2018 Tasvir H Rohila. All rights reserved.
//

#import "TrashViewController.h"
#import "SWRevealViewController.h"

@interface TrashViewController ()

@end

@implementation TrashViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
