//
//  ExpandableTableViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 03/08/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "MainViewController.h"

@interface ExpandableTableViewController : UITableViewController <UIAlertViewDelegate>

@property(nonatomic,strong) NSArray *items;
@property (nonatomic, retain) NSMutableArray *itemsInTable;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

//@property (nonatomic, retain) MainViewController *mainViewController;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;

@end
