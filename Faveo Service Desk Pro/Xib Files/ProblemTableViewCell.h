//
//  ProblemTableViewCell.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 03/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *problemNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;

@property (weak, nonatomic) IBOutlet UIView *indicationView;

@property (weak, nonatomic) IBOutlet UILabel *problemNumber;


@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;

@property (weak, nonatomic) IBOutlet UIView *mainView;


@end
