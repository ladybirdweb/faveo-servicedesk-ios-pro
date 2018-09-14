//
//  CreateProblem.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"


@interface CreateProblem : UITableViewController




//side menu outlet
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@property (nonatomic, strong) NSMutableArray * fromArray;
@property (nonatomic, strong) NSMutableArray * departmentArray;
@property (nonatomic, strong) NSMutableArray * impactArray;
@property (nonatomic, strong) NSMutableArray * statusArray;
@property (nonatomic, strong) NSMutableArray * locationArray;
@property (nonatomic, strong) NSMutableArray * priorityArray;
@property (nonatomic, strong) NSMutableArray * assignedArray;
@property (nonatomic, strong) NSMutableArray * assetArray;


- (IBAction)fromTextFieldClicked:(id)sender;

- (IBAction)impactTextFieldClicked:(id)sender;
- (IBAction)statusTextFieldClicked:(id)sender;

- (IBAction)priorityTextFieldClicked:(id)sender;
- (IBAction)departmentTextFieldClicked:(id)sender;
- (IBAction)locationTextFieldClicked:(id)sender;

- (IBAction)assigneeTextFieldClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)submitButtonClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *impactTextField;

@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;


@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;




@end
