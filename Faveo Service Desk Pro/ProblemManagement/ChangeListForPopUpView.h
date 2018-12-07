//
//  ChangeListForPopUpView.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 07/12/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChangeListForPopUpView : UIViewController

@property (weak, nonatomic) IBOutlet UITableView * sampleTableView;

@property (nonatomic) NSInteger page;

- (IBAction)closeButtonClicked:(id)sender;

- (IBAction)saveButtonClicked:(id)sender;


@end
