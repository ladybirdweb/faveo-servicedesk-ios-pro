//
//  ViewAttachedProblems.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 26/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewAttachedProblems : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *viewButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *detachButtonOutlet;

- (IBAction)viewButtonClicked:(id)sender;

- (IBAction)detachButtonClicked:(id)sender;



@end

NS_ASSUME_NONNULL_END
