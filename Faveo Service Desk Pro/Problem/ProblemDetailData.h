//
//  ProblemDetailData.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ProblemDetailData
 
 @brief This class used to show/display more details of the problem.
 
 @discussion It contains detailed informations like proble subject, problem description, from(owner), problem status, priority of the problem, location, source of the problems, department, impact of the problem and assets list assocciated with the problem.
 */
@interface ProblemDetailData : UITableViewController

/*!
 @property problemSubject
 
 @brief This is an textView property
 
 @discussion Used to show an existing subject data of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextView *problemSubject;

/*!
 @property problemDescription
 
 @brief This is an textView property
 
 @discussion Used to show an existing description data of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextView *problemDescription;

/*!
 @property fromTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing problem creator data of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;

/*!
 @property statusTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing status value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

/*!
 @property priorityTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing priority value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

/*!
 @property locationTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing location value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

/*!
 @property sourceTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing source value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *sourceTextField;

/*!
 @property assigneeTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing assignee/agent name value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *assigneeTextField;

/*!
 @property departmentTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing department value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;

/*!
 @property impactTextField
 
 @brief This is an textView property
 
 @discussion Used to show an existing impact value of the problem.
 */
@property (weak, nonatomic) IBOutlet UITextField *impactTextField;

//@property (weak, nonatomic) IBOutlet UITextField *assetsTextField;

@end
