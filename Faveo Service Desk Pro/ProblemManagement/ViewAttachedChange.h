//
//  ViewAttachedChange.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 18/01/19.
//  Copyright © 2019 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewAttachedChange : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *viewButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *detachButtonOutlet;

- (IBAction)viewButtonClicked:(id)sender;

- (IBAction)detachButtonClicked:(id)sender;


@end
