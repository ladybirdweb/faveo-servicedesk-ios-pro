//
//  NotificationViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 11/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

/*!
 @class NotificationViewController
 
 @brief This class used to show notifications list
 
 @discussion It contains an tableView. Using/calling notification API we will get notifications list and which is displying in to the tableView.
 
 */
@interface NotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

/*!
 @property tableView
 
 @brief This textView property. TableView is used to show list of notifications.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
