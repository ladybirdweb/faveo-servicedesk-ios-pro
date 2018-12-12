//
//  ChangeDetailView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/12/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChangeDetailView : UIViewController


/*!
 @property changeIdLabel
 
 @brief This is an label property
 
 @discussion It used to show/display id of the change.
 */
@property (weak, nonatomic) IBOutlet UILabel *changeIdLabel;

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
 @property assetsBarItem
 
 @brief This is an bar item/button property
 
 @discussion It used to show/display/represent button on the bar for asset.
 */
@property (weak, nonatomic) IBOutlet UITabBarItem *assetsBarItem;

@property (weak, nonatomic) IBOutlet UITabBarItem *updateChangeBarItem;

@property (weak, nonatomic) IBOutlet UITabBarItem *deleteChangeBarItem;

@property (weak, nonatomic) IBOutlet UITabBarItem *editChangeBarItem;

@property (weak, nonatomic) IBOutlet UITabBarItem *releaseTabBarItem;


/*!
 @method indexChanged
 
 @brief This is an segmented control action method
 
 @discussion This segmented control used to handle action to represents 2 views i.e tableView for each segment selection. For First segmented index i.e index = 0 it will show problem analyis data like Symptoms, Impact, Root cause and solution of that particular problem. For second segemented index i.e index =1 then it will show detailed decription of the problem like problem subject, message, crated date, owner, priority..etc
 
 @code
 
 - (IBAction)indexChanged:(id)sender;
 
 @endcode
 */
- (IBAction)indexChanged:(id)sender;

@end

