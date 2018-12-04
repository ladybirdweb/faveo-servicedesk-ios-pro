//
//  AddCCViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 11/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class AddCCViewController
 
 @brief This class used to add cc to the particular ticket.
 
 @discussion Here user can able to search the cc that he wants to add to the ticket. After giving some input it will show some dropdown menu which contains list of user, once user selected any one of the cc then it will be added to the ticket after clickinng on add button on same view.
 
 */
@interface AddCCViewController : UITableViewController


/*!
 @property tablview
 
 @brief This is tableView property used for some internal implementation purpose.
 */
@property (strong, nonatomic) IBOutlet UITableView *tableview;

/*!
 @property ccTextField
 
 @brief This is textField property used to type some data.
 */
@property (weak, nonatomic) IBOutlet UITextField *ccTextField;

@property (weak, nonatomic) IBOutlet UIButton *addButtonOutlet;


/*!
 @property searchLabel
 
 @brief This is label property used show an label name call Search CC.
 */
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;

/*!
 @method addButtonAction
 
 @brief This is an button action.
 
 @discussion After clicking this button add cc API will call.
 @code
 
 - (IBAction)addButtonAction:(id)sender;
 
 @endcode
 */
- (IBAction)addButtonAction:(id)sender;

@end
