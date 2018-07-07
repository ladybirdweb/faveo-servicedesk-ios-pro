//
//  ClientDetailsViewController.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientDetailsViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *testingLAbel;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@property (weak, nonatomic) IBOutlet UILabel *rolLabel;

@property(nonatomic,strong) NSString * emailID;
@property(nonatomic,strong) NSString * isClientActive;
@property(nonatomic,strong) NSString * phone;
@property(nonatomic,strong) NSString * clientName;
@property(nonatomic,strong) NSString * clientId;
@property (strong,nonatomic) NSString *imageURL;

-(void)setUserProfileimage:(NSString*)imageUrl;


@end
