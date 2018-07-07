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


@property (weak, nonatomic) IBOutlet UIImageView *addRequesterImage;

@property (weak, nonatomic) IBOutlet UITextField *ccTextField;

@property (weak, nonatomic) IBOutlet UITextView *firstNameTextView;


@property (weak, nonatomic) IBOutlet UITextView *lastNameTextView;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextView *mobileTextView;

@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UITextField *helptopicTextField;

@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;

- (IBAction)countryCodeClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

- (IBAction)priorityClicked:(id)sender;

- (IBAction)helptopicClicked:(id)sender;

- (IBAction)assigneeClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *submitButtonOutlet;

- (IBAction)submitButtonClicked:(id)sender;


@property (nonatomic, strong) NSDictionary * countryDic;
@property (nonatomic, strong) NSMutableArray * staffArray;
@property (nonatomic, strong) NSArray * codeArray;
@property (nonatomic, strong) NSArray * countryArray;
@property (nonatomic, strong) NSArray * priorityArray;
@property (nonatomic, strong) NSArray * helptopicsArray;


@property (weak, nonatomic) IBOutlet UIImageView *fileImage;

@property (weak, nonatomic) IBOutlet UILabel *fileName123;

@property (weak, nonatomic) IBOutlet UILabel *fileSize123;



@end
