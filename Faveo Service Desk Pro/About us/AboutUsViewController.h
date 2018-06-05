//
//  AboutUsViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewOutlet;

@property (weak, nonatomic) IBOutlet UIButton *websiteButtonOutlet;

- (IBAction)websiteButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
