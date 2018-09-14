//
//  ProblemList.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface ProblemList : UIViewController



@property (weak, nonatomic) IBOutlet UITableView *sampleTableview;

//side menu outlet
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (nonatomic) NSInteger page;


@end
