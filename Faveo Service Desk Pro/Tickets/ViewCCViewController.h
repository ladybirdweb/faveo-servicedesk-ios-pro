//
//  ViewCCViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 11/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCCViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>




@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property (weak, nonatomic) IBOutlet UIButton *removeCCLabel;

@property (weak, nonatomic) IBOutlet UIButton *removeCCFinalLabel;

- (IBAction)removeCCButton:(id)sender;

- (IBAction)removeCCFinalButton:(id)sender;



@end
