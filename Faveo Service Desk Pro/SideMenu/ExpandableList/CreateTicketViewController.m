//
//  CreateTicketViewController.m
//  ExpandableList
//
//  Created by Mallikarjun on 31/05/18.
//  Copyright © 2018 Tasvir H Rohila. All rights reserved.
//

#import "CreateTicketViewController.h"
#import "InboxViewController.h"
@interface CreateTicketViewController ()

@end

@implementation CreateTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButton:(id)sender {
    
    InboxViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"inboxID"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
