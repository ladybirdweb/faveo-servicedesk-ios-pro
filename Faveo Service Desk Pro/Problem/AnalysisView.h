//
//  AnalysisView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalysisView : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *sampleTableview;

@property (weak, nonatomic) IBOutlet UITextView *rootCauseTextView;

@property (weak, nonatomic) IBOutlet UITextView *impactTextView;

@property (weak, nonatomic) IBOutlet UITextView *symptomsTextView;

@property (weak, nonatomic) IBOutlet UITextView *solutionTextView;


@end
