//
//  TicketDetailViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 @class TicketDetailViewController
 
 @brief This class contains details of a ticket.
 
 @discussion This contain details of a ticket like Subject, Priority, HelpTopic, Name, email, source, ticket type and sue date.
 Here agent can edit things like subject, ticket priority,HelpTopic and Source.
 */
@interface TicketDetailViewController : UIViewController

/*!
 @property segmentedControl
 
 @brief This propert is an instance of a UISegmentedControl.
 
 @discussion A segmented control is a linear set of two or more segments, each of which functions as a mutually exclusive button. Within the control, all segments are equal in width.
 Like buttons, segments can contain text or images. Segmented controls are often used to display different views.
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

/*!
 @property containerView
 
 @brief At runtime, a view object handles the rendering of any content in its area and also handles any interactions with that content.
 */
@property (weak, nonatomic) IBOutlet UIView *containerView;

/*!
 @property currentViewController
 
 @brief A view controller manages a set of views that make up a portion of your app’s user interface. It is responsible for loading and disposing of those views, for managing interactions with those views, and for coordinating responses with any appropriate data objects. View controllers also coordinate their efforts with other controller objects—including other view controllers—and help manage your app’s overall interface.
 */
@property (weak, nonatomic) UIViewController *currentViewController;

/*!
 @property ticketNumber
 
 @brief This property used for dislaying ticket number.
 */
@property(nonatomic,strong) NSString *ticketNumber;

/*!
 @property ticketLabel
 
 @brief This lebel property used for dislaying ticket name.
 */
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;

/*!
 @property nameLabel
 
 @brief This property used for dislaying owner name.
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/*!
 @property statusLabel
 
 @brief This property used for dislaying ticket status.
 */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

/*!
 @property asstetTabBarItem
 
 @brief This tab bar button item  used for showing menu.
 */
@property (weak, nonatomic) IBOutlet UITabBarItem *asstetTabBarItem;

/*!
 @property problemTabBarItem
 
 @brief This tab bar button item  used for showing problem menu.
 */
@property (weak, nonatomic) IBOutlet UITabBarItem *problemTabBarItem;

/*!
 @property replyTabBarItem
 
 @brief This tab bar button item  , after clicking this button it will navigate to ticket reply page.
 */
@property (weak, nonatomic) IBOutlet UITabBarItem *replyTabBarItem;


/*!
 @property internalNoteTabBarItem
 
 @brief This tab bar button item  , after clicking this button it will navigate to add internal note.
 */
@property (weak, nonatomic) IBOutlet UITabBarItem *internalNoteTabBarItem;

/*!
 @property tableView
 
 @brief This propert is an instance of a table view.
 
 @discussion Table views are versatile user interface objects frequently found in iOS apps. A table view presents data in a scrollable list of multiple rows that may be divided into sections.
 */
@property (strong, nonatomic) IBOutlet UITableView *tableview;


/*!
 @method viewDidLoad
 
 @brief This in an Button action
 
 @discussion This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView method.
 
 @code
 
 -(void)viewDidLoad;
 
 @endocde
 
 */
-(void)viewDidLoad;

/*!
 @method getProblemAssociatedWithTicket
 
 @brief This in normal method with not argument and without return value.
 
 @discussion This method is used to get problems which are associated with tickets.
 
 @code
 
-(void)getProblemAssociatedWithTicket;
 
 @endocde
 
 */
-(void)getProblemAssociatedWithTicket;


/*!
 @method indexChanged
 
 @brief This in an Button. After clicking perticluar ticket it redirect to redirect to Ticket Detail page.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 - (IBAction)indexChanged:(id)sender;
 
 @endocde
 
 */
- (IBAction)indexChanged:(id)sender;


@end
