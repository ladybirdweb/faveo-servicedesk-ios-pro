//
//  ProblemTableViewCell.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 03/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ProblemTableViewCell.h"
#import "HexColors.h"

@implementation ProblemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.indicationView.bounds
                              byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(10, 10)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.indicationView.layer.mask = maskLayer;
    
    self.selectionStyle=UITableViewCellSelectionStyleDefault;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
