//
//  ProblemDetailData.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemDetailData : UITableViewController


@property (weak, nonatomic) IBOutlet UITextView *problemSubject;

@property (weak, nonatomic) IBOutlet UITextView *problemDescription;

@property (weak, nonatomic) IBOutlet UITextField *fromTextField;

@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UITextField *sourceTextField;

@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;

@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;

@property (weak, nonatomic) IBOutlet UITextField *impactTextField;


@end
