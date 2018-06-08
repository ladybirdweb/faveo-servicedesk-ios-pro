//
//  InboxTicketsViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxTickets : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    BOOL searching;
}


//side menu outlet
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

//tableview instance
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic) NSInteger page;


@property (strong, nonatomic) NSMutableArray *sampleDataArray;
@property (strong, nonatomic) NSMutableArray *filteredSampleDataArray;


-(void)hideTableViewEditMode;


//-(void)showMessageForLogout:(NSString*)message sendViewController:(UIViewController *)viewController;



@end
