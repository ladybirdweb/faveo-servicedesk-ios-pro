//
//  ViewCCViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 11/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ViewCCViewController
 
 @brief This class used to show list of CC.
 
 @discussion TableView is used in order to shown cc list, user can able to remove cc from the tableView - 1 cc he can remove at a time.
 
 */
@interface ViewCCViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


/*!
 @property tableview
 
 @brief This tableView property used for internal purpose.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableview;

/*!
 @property removeCCLabel
 
 @brief This label property used to show an label
 */
@property (weak, nonatomic) IBOutlet UIButton *removeCCLabel;

/*!
 @property removeCCFinalLabel
 
 @brief This label property used to show an label and acts as a button and remove cc
 */
@property (weak, nonatomic) IBOutlet UIButton *removeCCFinalLabel;

/*!
 @method removeCCButton
 
 @brief This is an button action method.
 
 @discussion After clicking this button it will remove cc from the ticket.
 
 @code
 
 - (IBAction)removeCCButton:(id)sender;
 
 @endcode
 
 */
- (IBAction)removeCCButton:(id)sender;

/*!
 @method removeFinalButton
 
 @brief This is an button action method.
 
 @discussion After clicking this button it will remove cc from the ticket.
 
 @code
 
 - (IBAction)removeFinalButton:(id)sender;
 
 @endcode
 */
- (IBAction)removeCCFinalButton:(id)sender;



@end
