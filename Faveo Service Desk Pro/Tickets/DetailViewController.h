//
//  DetailViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UITableViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;
@property (weak, nonatomic) IBOutlet UITextField *helptopicTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;


@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *sourceTextField;


@property (weak, nonatomic) IBOutlet UITextField *ticketTypeTextField;

@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;

@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;

@property (weak, nonatomic) IBOutlet UITextField *createdTextField;

@property (weak, nonatomic) IBOutlet UITextField *lastResponseTextField;


@end
