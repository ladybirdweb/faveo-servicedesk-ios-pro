//
//  MultipleTicketAssignView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 29/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultipleTicketAssignView : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;

@property (weak, nonatomic) IBOutlet UILabel *assignLabel;

@property (weak, nonatomic) IBOutlet UITextField *assinTextField;

//selectAssignee

- (IBAction)selectAssignee:(id)sender;

@end
