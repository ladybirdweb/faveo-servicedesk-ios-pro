//
//  ClientFilter.h
//  Faveo Helpdesk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientFilter : UIViewController


//It is an barItemButton instance used to enable side-menu 
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


/*!
 @property page
 
 @brief This integer property used to store page number.
 */
@property (nonatomic) NSInteger page;
@end
