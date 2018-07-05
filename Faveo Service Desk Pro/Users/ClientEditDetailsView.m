//
//  ClientEditDetailsView.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ClientEditDetailsView.h"
#import "GlobalVariables.h"
#import "ClientDetailsViewController.h"
#import "Utils.h"
#import "Reachability.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "UIColor+HexColors.h"
#import "SVProgressHUD.h"
#import "MyWebservices.h"
#import "AppConstanst.h"

@interface ClientEditDetailsView ()<RMessageProtocol,UITextFieldDelegate>
{
    
    Utils *utils;
    UIRefreshControl *refresh;
    NSUserDefaults *userDefaults;
    NSMutableArray *array1;
    NSDictionary *priDicc1;
    GlobalVariables *globalVariables;
    NSString * msg;

}
@end

@implementation ClientEditDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=NSLocalizedString(@"Edit Profile", nil);
    
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    

    
    UIButton *done =  [UIButton buttonWithType:UIButtonTypeCustom];
    [done setImage:[UIImage imageNamed:@"doneButton"] forState:UIControlStateNormal];
    [done addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [done setFrame:CGRectMake(44, 0, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    // [rightBarButtonItems addSubview:addBtn];
    [rightBarButtonItems addSubview:done];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    // textfield add button manually
    
    UIToolbar *toolBar= [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *removeBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain  target:self action:@selector(removeKeyBoard)];
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:space,removeBtn, nil]];
    
    [self.userNameTextField setInputAccessoryView:toolBar];
    [self.firstNameTextField setInputAccessoryView:toolBar];
    [self.lastNameTextField setInputAccessoryView:toolBar];
    [self.emailTextField setInputAccessoryView:toolBar];
    

    
    _userNameTextField.text= [NSString stringWithFormat:@"%@",globalVariables.userNameFromUserList];
    _firstNameTextField.text= [NSString stringWithFormat:@"%@",globalVariables.First_nameFromUserList];
    _lastNameTextField.text= [NSString stringWithFormat:@"%@",globalVariables.Last_nameFromUserList];
    _emailTextField.text= [NSString stringWithFormat:@"%@",globalVariables.emailFromUserList];
    
    _submitButton.backgroundColor=[UIColor colorFromHexString:@"00aeef"];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)removeKeyBoard
{
    
    [_userNameTextField resignFirstResponder];
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return  YES;
}


- (IBAction)submitButtonAction:(id)sender {
    
    
      [self submit];
}

-(void)submit
{
    
    if(_userNameTextField.text.length==0 || _firstNameTextField.text.length==0 || _lastNameTextField.text.length==0 || _emailTextField.text.length==0)
    {
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO];
        }
        
        [RMessage showNotificationInViewController:self.navigationController
                                             title:NSLocalizedString(@"Warning !", nil)
                                          subtitle:NSLocalizedString(@"Please fill mandatory fields.", nil)
                                         iconImage:nil
                                              type:RMessageTypeWarning
                                    customTypeName:nil
                                          duration:RMessageDurationAutomatic
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionNavBarOverlay
                              canBeDismissedByUser:YES];
        
        
    }
    else{
        
        [SVProgressHUD showWithStatus:@"Saving details"];
        [self doneSubmitMethod];
        
        
    }
}


//after validating all fields if everythig is fine then below method i.e edit user API is called
-(void)doneSubmitMethod
{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO];
        }
        
        [RMessage showNotificationInViewController:self.navigationController
                                             title:NSLocalizedString(@"Error..!", nil)
                                          subtitle:NSLocalizedString(@"There is no Internet Connection...!", nil)
                                         iconImage:nil
                                              type:RMessageTypeError
                                    customTypeName:nil
                                          duration:RMessageDurationAutomatic
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionNavBarOverlay
                              canBeDismissedByUser:YES];
        
        [SVProgressHUD dismiss];
        
    }else{
        
       //[[AppDelegate sharedAppdelegate] showProgressView];
        
        NSString *url =[NSString stringWithFormat:@"%@api/v2/helpdesk/user-edit/%@?api_key=%@&token=%@&user_name=%@&first_name=%@&last_name=%@&email=%@",[userDefaults objectForKey:@"baseURL"],globalVariables.userIDFromUserList,API_KEY,[userDefaults objectForKey:@"token"],_userNameTextField.text,_firstNameTextField.text,_lastNameTextField.text,_emailTextField.text];
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            
            
            [webservices callPATCHAPIWithAPIName:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                
                
                if (error || [msg containsString:@"Error"]) {
                    
                    [SVProgressHUD dismiss];
                    
                    if (msg) {
                        if([msg isEqualToString:@"Error-403"])
                        {
                            [self->utils showAlertWithMessage:NSLocalizedString(@"Access Denied - You don't have permission.", nil) sendViewController:self];
                            
                        }
                        else if([msg isEqualToString:@"Error-402"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access denied - Either your role has been changed or your login credential has been changed."] sendViewController:self];
                        }
                        else if([msg isEqualToString:@"Error-422"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Enter the data for mandatory fields or Enter valid Email. "] sendViewController:self];
                            
                        }
                        else{
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                            NSLog(@"Error is : %@",msg);
                           
                        }
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-EditCustomerDetails-Refresh-error == %@",error.localizedDescription);
                        [SVProgressHUD dismiss];
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self doneSubmitMethod];
                    NSLog(@"Thread--NO4-call-EditCustomerDetails");
                    return;
                }
                
                
                if (json) {
                    NSLog(@"JSON-EditCustomerDetails-%@",json);
                    
                    NSDictionary *userData=[json objectForKey:@"data"];
                    NSString *msg=[userData objectForKey:@"message"];
                    
                    
                    if([msg isEqualToString:@"Updated successfully"]){
                        
                        if (self.navigationController.navigationBarHidden) {
                            [self.navigationController setNavigationBarHidden:NO];
                        }
                        
                        [RMessage showNotificationInViewController:self.navigationController
                                                             title:NSLocalizedString(@"Success", nil)
                                                          subtitle:NSLocalizedString(@"Details Updated successfully.", nil)
                                                         iconImage:nil
                                                              type:RMessageTypeSuccess
                                                    customTypeName:nil
                                                          duration:RMessageDurationAutomatic
                                                          callback:nil
                                                       buttonTitle:nil
                                                    buttonCallback:nil
                                                        atPosition:RMessagePositionNavBarOverlay
                                              canBeDismissedByUser:YES];
                        
                        
                        
                        self->globalVariables.userNameFromUserList= self->_userNameTextField.text;
                        self->globalVariables.First_nameFromUserList= self->_firstNameTextField.text;
                        self-> globalVariables.Last_nameFromUserList=self->_lastNameTextField.text;
                        self->globalVariables.emailFromUserList=self-> _emailTextField.text;
                        
                        
                        self->globalVariables=[GlobalVariables sharedInstance];
                        
                        
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                        
                    }else
                    {
                        [self->utils showAlertWithMessage:@"Something went wrong. Please try again later." sendViewController:self];
                        [SVProgressHUD dismiss];
                        
                    }
                    
                    
                }
                
                NSLog(@"Thread-NO5-EditCustomerDetails-closed");
                
            }];
        }@catch (NSException *exception)
        {
            [utils showAlertWithMessage:exception.name sendViewController:self];
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            return;
        }
        @finally
        {
            NSLog( @" I am in doneSubmitButton method in EditClientDetails ViewController" );
            
        }
        
    }
}



@end
