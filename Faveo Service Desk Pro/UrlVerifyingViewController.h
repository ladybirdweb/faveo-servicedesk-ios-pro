//
//  UrlVerifyingViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 21/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UrlVerifyingViewController : UIViewController



@property (weak, nonatomic) IBOutlet UITextField *urlTextField;


@property (weak, nonatomic) IBOutlet UIButton *nextButtonOutlet;

- (IBAction)nextButtonActionMethod:(id)sender;


@end
