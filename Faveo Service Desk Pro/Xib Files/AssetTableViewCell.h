//
//  AssetTableViewCell.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 21/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *assetIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetTitleLabel;


@end

NS_ASSUME_NONNULL_END
