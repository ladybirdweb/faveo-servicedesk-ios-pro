//
//  AddRequester.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 11/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRequester : UITableViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;


@property (weak, nonatomic) IBOutlet UIButton *submitButtonOutlet;
- (IBAction)submitButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *headerTitleView;

@property (nonatomic, strong) NSArray * countryArray;
@property (nonatomic, strong) NSArray * codeArray;

@property (nonatomic, strong) NSDictionary * countryDic;

- (IBAction)countryClicked:(id)sender;


@end
