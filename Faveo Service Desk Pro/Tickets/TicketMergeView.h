//
//  TicketMergeView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 29/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketMergeView : UITableViewController <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *newtitleTextview;


@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;

@property (weak, nonatomic) IBOutlet UITextField *parentTicketTextField;

@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;

@property (weak, nonatomic) IBOutlet UILabel *mergeLabel;


- (IBAction)SelectParentTicket:(id)sender;


@end