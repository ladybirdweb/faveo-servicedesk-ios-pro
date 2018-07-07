//
//  TrashTickets.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrashTickets : UIViewController

//side menu outlet
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSInteger page;

@end



