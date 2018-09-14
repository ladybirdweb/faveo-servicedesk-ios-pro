//
//  ProblemDetailView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemDetailView : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)indexChanged:(id)sender;

@property (weak, nonatomic) UIViewController *currentViewController;

@property (weak, nonatomic) IBOutlet UILabel *problemSubject;

@property (weak, nonatomic) IBOutlet UILabel *problemDetails;

@end
