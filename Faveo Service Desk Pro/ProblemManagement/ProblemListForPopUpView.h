//
//  ProblemListForPopUpView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/10/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ProblemListForPopUpView
 
 @brief This class used to show an pop-up view (it acts like an pop up view)
 
 @discussion Basically it contains an tableView which will show an existing problem list when user clicks on the button of 'Add Existin Problem' in ticket details page. Agent/Admin can able to see existing problem list and can ablet to select and attach to the specific problem.
 */
@interface ProblemListForPopUpView : UIViewController

/*!
 @property sampleTableView
 
 @brief This propert is an instance of a table view.
 
 @discussion Table views are versatile user interface objects frequently found in iOS apps. A table view presents data in a scrollable list of multiple rows that may be divided into sections.
 */
@property (weak, nonatomic) IBOutlet UITableView * sampleTableView;

/*!
 @property page
 
 @brief This integer property used represent page number
 */
@property (nonatomic) NSInteger page;

/*!
@method closeButtonClicked

@brief This is an button action method

@discussion After clicking 'Closed' button it will dismiss the pop-up from the current view.

@code

- (IBAction)closeButtonClicked:(id)sender;

@endcode
*/
- (IBAction)closeButtonClicked:(id)sender;


/*!
 @method saveButtonClicked
 
 @brief This is an button action method
 
 @discussion After clicking 'Save' button it will save the selected problem id and attached to the specific ticket.
 
 @code
 
 - (IBAction)saveButtonClicked:(id)sender;
 
 @endcode
 */
- (IBAction)saveButtonClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *vcTitleNameLabel;

@end

