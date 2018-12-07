//
//  ChangesTableViewCell.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/12/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangesTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *changeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *requesterLabel;

@property (weak, nonatomic) IBOutlet UIView *indicationView;

@property (weak, nonatomic) IBOutlet UILabel *changeNumber;

@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;

@property (weak, nonatomic) IBOutlet UIView *mainView;


@end
