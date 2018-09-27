//
//  TicketDetailViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketDetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) UIViewController *currentViewController;

@property(nonatomic,strong) NSString *ticketNumber;

@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)indexChanged:(id)sender;


@property (weak, nonatomic) IBOutlet UITabBarItem *asstetTabBarItem;

@property (weak, nonatomic) IBOutlet UITabBarItem *problemTabBarItem;

@property (weak, nonatomic) IBOutlet UITabBarItem *replyTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *internalNoteTabBarItem;

@property (strong, nonatomic) IBOutlet UITableView *tableview;

-(void)viewDidLoad;
-(void)getProblemAssociatedProblemDetails;


@end
