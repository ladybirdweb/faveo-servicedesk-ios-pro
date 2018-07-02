//
//  SearchViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 29/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *seachTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableview1;
@property (nonatomic, strong) NSString *path1;

@property (nonatomic) NSInteger page;
@property (weak, nonatomic) IBOutlet UITableView *tableview2;


@end
