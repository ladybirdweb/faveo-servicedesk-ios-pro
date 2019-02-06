//
//  ProblemDetailView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ProblemDetailView
 
 @brief This class used to show/display more details of the problem.
 
 @discussion This class contains 2 tableView, one tableView used to present problem modules like Symptoms, Solutions ..etc and other is for problems details. Using Segmented control the selection of the tableVIew is handled.
 */
@interface ProblemDetailView : UIViewController

/*!
 @property problemIdLabel
 
 @brief This is an label property
 
 @discussion It used to show/display id of the problem.
 */
@property (weak, nonatomic) IBOutlet UILabel *problemIdLabel;

/*!
 @property segmentedControl
 
 @brief This is an segmentedControl outlet
 
 @discussion It used to control two segments
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

/*!
 @property containerView
 
 @brief This is an view property
 
 @discussion It used to as view to represents some another views inside this view.
 */
@property (weak, nonatomic) IBOutlet UIView *containerView;

/*!
 @property currentViewController
 
 @brief This is an viewController property
 
 @discussion It used to as view to represents current viewController
 */
@property (weak, nonatomic) UIViewController *currentViewController;


/*!
 @property problemSubject
 
 @brief This is an label property
 
 @discussion It used to show/display/represent subject of the problem.
 */
@property (weak, nonatomic) IBOutlet UILabel *problemSubject;

/*!
 @property problemDetails
 
 @brief This is an label property
 
 @discussion It used to show/display/represent details of the problem.
 */
@property (weak, nonatomic) IBOutlet UILabel *problemDetails;

/*!
 @property ticketBarItem
 
 @brief This is an bar item/button property
 
 @discussion It used to show/display/represent button on the bar for ticket.
 */
@property (weak, nonatomic) IBOutlet UITabBarItem *ticketBarItem;

/*!
 @property assetBarItem
 
 @brief This is an bar item/button property
 
 @discussion It used to show/display/represent button on the bar for asset.
 */
@property (weak, nonatomic) IBOutlet UITabBarItem *assetBarItem;

/*!
 @method indexChanged
 
 @brief This is an segmented control action method
 
 @discussion This segmented control used to handle action to represents 2 views i.e tableView for each segment selection. For First segmented index i.e index = 0 it will show problem analyis data like Symptoms, Impact, Root cause and solution of that particular problem. For second segemented index i.e index =1 then it will show detailed decription of the problem like problem subject, message, crated date, owner, priority..etc
 
 @code
 
 - (IBAction)indexChanged:(id)sender;
 
 @endcode
 */
- (IBAction)indexChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UITabBarItem *changeTabBarItem;


@end
