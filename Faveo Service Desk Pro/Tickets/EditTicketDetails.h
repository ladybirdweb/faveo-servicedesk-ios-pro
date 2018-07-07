//
//  EditTicketDetails.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTicketDetails : UITableViewController

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;
@property (weak, nonatomic) IBOutlet UITextField *helptopicsTextField;

@property (weak, nonatomic) IBOutlet UITextField *sourceTextField;

@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;


@property (nonatomic, assign) NSInteger selectedIndex;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)priorityClicked:(id)sender;
- (IBAction)helptopicClicked:(id)sender;
- (IBAction)sourceClicked:(id)sender;
- (IBAction)typeClicked:(id)sender;
- (IBAction)assigneeClicked:(id)sender;

- (IBAction)saveButtonAction:(id)sender;


@property (nonatomic, strong) NSArray * helptopicsArray;

@property (nonatomic, strong) NSArray * deptArray;

@property (nonatomic, strong) NSArray * priorityArray;

@property (nonatomic, strong) NSArray * sourceArray;

@property (nonatomic, strong) NSArray * typeArray;



@end
