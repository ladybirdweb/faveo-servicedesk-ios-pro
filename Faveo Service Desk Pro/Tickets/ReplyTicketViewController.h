//
//  ReplyTicketViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 09/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ReplyTicketViewController
 
 @brief This class used to give reply to the ticket.
 
 @discussion In this reply view user can able to see existing cc names and can able to add new cc to the ticket while giving an reply to the ticket.
 
 */
@interface ReplyTicketViewController : UITableViewController


/*!
 @property tableview
 
 @brief This is tableView instance used for internal purpose.
 */
@property (strong, nonatomic) IBOutlet UITableView *tableview;

/*!
 @property messageTextView
 
 @brief This textView used add an message for the ticket.
 */
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

/*!
 @property addCCLabel
 
 @brief This is label property and used as an button. After clicking this button it will navigate to the add cc view.
 */
@property (weak, nonatomic) IBOutlet UILabel *addCCLabel;

@property (weak, nonatomic) IBOutlet UILabel *viewCCLabel;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButtonOutlet;

/*!
 @property fileImage
 
 @brief This is imageView property used to show and icon for the selected attachment.
 */
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;

/*!
 @property fileName123
 
 @brief This is label property used to show file name for the selected attachment.
 */
@property (weak, nonatomic) IBOutlet UILabel *fileName123;

/*!
 @property fileSize123
 
 @brief This is label property used to show file size for the selected attachment.
 */
@property (weak, nonatomic) IBOutlet UILabel *fileSize123;


/*!
 @method submitButtonClicked
 
 @brief This method is called when after adding an message to the ticket and adding cc this will add an reply to the ticket.
 
 @code
 
 -(IBAction)submitButtonClicked:(id)sender;
 
 @endcode
 
 */
- (IBAction)submitButtonAction:(id)sender;



@end
