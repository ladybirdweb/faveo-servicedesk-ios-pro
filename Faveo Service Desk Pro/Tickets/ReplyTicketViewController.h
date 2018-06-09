//
//  ReplyTicketViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 09/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyTicketViewController : UITableViewController



@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UILabel *addCCLabel;

@property (weak, nonatomic) IBOutlet UILabel *viewCCLabel;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButtonOutlet;

- (IBAction)submitButtonAction:(id)sender;



@end
