//
//  ClientListViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class ClientListViewController
 
 @brief This class contains list of Clients.
 
 @discussion This class contains a table view and it gives a list of Clients. After clicking a particular client cell we can see name of client, email id, profile picture, contact number.
 Also it will show client is active and inactive.
 It contains a list of messages that he was created.
 */
@interface ClientListViewController : UIViewController

//It is an barItemButton instance used to enable side-menu 
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;




@end
