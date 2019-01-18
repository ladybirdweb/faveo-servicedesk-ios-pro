//
//  ChangeAnalysisView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 18/01/19.
//  Copyright © 2019 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChangeAnalysisView : UITableViewController

/*!
 @property sampleTableview
 
 @brief This propert is an instance of a table view.
 
 @discussion Table views are versatile user interface objects frequently found in iOS apps. A table view presents data in a scrollable list of multiple rows that may be divided into sections.
 */
@property (strong, nonatomic) IBOutlet UITableView *sampleTableview;


@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;

@property (weak, nonatomic) IBOutlet UITextView *impactTextView;

@property (weak, nonatomic) IBOutlet UITextView *rolloutPlanTextView;

@property (weak, nonatomic) IBOutlet UITextView *backoutPlanTextView;

@end
