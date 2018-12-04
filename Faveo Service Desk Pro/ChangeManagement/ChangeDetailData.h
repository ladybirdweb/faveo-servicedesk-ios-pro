//
//  ChangeDetailData.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/12/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChangeDetailData : UITableViewController


@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UITextField *requesterTextField;
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

@property (weak, nonatomic) IBOutlet UITextField *changeTextField;

@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UITextField *impactTextField;

@end
