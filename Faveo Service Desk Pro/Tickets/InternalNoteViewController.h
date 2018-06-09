//
//  InternalNoteViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 09/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternalNoteViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;


@property (weak, nonatomic) IBOutlet UIButton *submitButtonOutlet;

- (IBAction)submitButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *noteContentLabel;


@end
