//
//  AnalysisView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ProblemDetailView
 
 @brief This class contains tableView.
 
 @discussion It used to show/display Root Cause, Impact, Symptoms and Solution details of the problem if not provided then it will show like 'no data added'. Agent/Admin can able to update/modify/edit this details.
 */
@interface AnalysisView : UITableViewController

/*!
 @property sampleTableview
 
 @brief This propert is an instance of a table view.
 
 @discussion Table views are versatile user interface objects frequently found in iOS apps. A table view presents data in a scrollable list of multiple rows that may be divided into sections.
 */
@property (strong, nonatomic) IBOutlet UITableView *sampleTableview;

/*!
 @property rootCauseTextView
 
 @brief This is an textView property
 
 @discussion Used to show an existing value of root cause.
 */
@property (weak, nonatomic) IBOutlet UITextView *rootCauseTextView;

/*!
 @property impactTextView
 
 @brief This is an textView property
 
 @discussion Used to show an existing value of impact.
 */
@property (weak, nonatomic) IBOutlet UITextView *impactTextView;

/*!
 @property symptomsTextView
 
 @brief This is an textView property
 
 @discussion Used to show an existing value of symptoms.
 */
@property (weak, nonatomic) IBOutlet UITextView *symptomsTextView;

/*!
 @property solutionTextView
 
 @brief This is an textView property
 
 @discussion Used to show an existing value of solution.
 */
@property (weak, nonatomic) IBOutlet UITextView *solutionTextView;


@end
