//
//  NotificationViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 11/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
