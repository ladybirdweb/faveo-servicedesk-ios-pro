//
//  AddCCViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 11/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCCViewController : UITableViewController



@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UITextField *ccTextField;

@property (weak, nonatomic) IBOutlet UIButton *addButtonOutlet;

- (IBAction)addButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *searchLabel;


@end
