//
//  CreateTicketView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTicketView : UITableViewController


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITextView *emailTextView;

@property (weak, nonatomic) IBOutlet UITextField *ccTextField;

@property (weak, nonatomic) IBOutlet UITextView *firstNameTextView;
@property (weak, nonatomic) IBOutlet UITextView *lastNameTextView;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextView *mobileTextView;


@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

@property (weak, nonatomic) IBOutlet UITextField *helptopicTextField;

@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;



- (IBAction)countryClicked:(id)sender;

- (IBAction)priorityClicked:(id)sender;

- (IBAction)helptopicClicked:(id)sender;

- (IBAction)assigneeClicked:(id)sender;

- (IBAction)submitButtonClicked:(id)sender;



@end
