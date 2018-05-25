//
//  MenuViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface LeftMenuViewController : UITableViewController


@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

@property (weak, nonatomic) IBOutlet UIImageView *user_profileImage;
@property (weak, nonatomic) IBOutlet UILabel *user_role;
@property (weak, nonatomic) IBOutlet UILabel *url_label;
@property (weak, nonatomic) IBOutlet UILabel *user_nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *inbox_countLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTickets_countLabel;
@property (weak, nonatomic) IBOutlet UILabel *unassigned_countLabel;
@property (weak, nonatomic) IBOutlet UILabel *closed_countLabel;
@property (weak, nonatomic) IBOutlet UILabel *trash_countLabel;

@property (weak, nonatomic) IBOutlet UILabel *c1;
@property (weak, nonatomic) IBOutlet UILabel *c2;
@property (weak, nonatomic) IBOutlet UILabel *c3;
@property (weak, nonatomic) IBOutlet UILabel *c4;
@property (weak, nonatomic) IBOutlet UILabel *c5;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

@property (weak, nonatomic) IBOutlet UIView *view5;



//-(void)update;
//-(void)reloadd;
//-(void)addUIRefresh;
//-(void)wipeDataInLogout;






















@end
