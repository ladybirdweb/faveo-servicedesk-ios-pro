//
//  ChangeDetailData.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 18/01/19.
//  Copyright © 2019 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ChangeDetailData.h"
#import "ChangeAnalysisView.h"
#import "Utils.h"
#import "MyWebservices.h"
#import "GlobalVariables.h"
#import "SVProgressHUD.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "Reachability.h"
#import "ChangeDetailView.h"
#import "UIColor+HexColors.h"
#import "HexColors.h"


@interface ChangeDetailData ()<UITextFieldDelegate>
{
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
}

@end

@implementation ChangeDetailData

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    
    //problem subject textview
    self.subjectTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.subjectTextView.layer.borderWidth = 0.4;
    self.subjectTextView.layer.cornerRadius = 3;
    
    //problem desc textview
    self.descriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.descriptionTextView.layer.borderWidth = 0.4;
    self.descriptionTextView.layer.cornerRadius = 3;
    
    
    _subjectTextView.userInteractionEnabled = NO;
    _descriptionTextView.userInteractionEnabled = NO;
    _requesterTextField.userInteractionEnabled = NO;
    _statusTextField.userInteractionEnabled = NO;
    _priorityTextField.userInteractionEnabled = NO;
    _locationTextField.userInteractionEnabled = NO;
    _changeTextField.userInteractionEnabled = NO;
    _impactTextField.userInteractionEnabled = NO;
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"Please wait"];
    
    [self reload];
}




-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        
        // [[AppDelegate sharedAppdelegate] hideProgressView];
        [SVProgressHUD dismiss];
        
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
        
        
        
    }else{
        
        
        NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/change/editbind/%@?token=%@",[userDefaults objectForKey:@"baseURL"],globalVariables.changeId,[userDefaults objectForKey:@"token"]];
        
        NSLog(@"URL is : %@",url);
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                
                if (error || [msg containsString:@"Error"]) {
                    
                    [SVProgressHUD dismiss];
                    
                    if (msg) {
                        
                        
                        
                        if([msg isEqualToString:@"Error-403"])
                        {
                            [self->utils showAlertWithMessage:NSLocalizedString(@"Access Denied - You don't have permission.", nil) sendViewController:self];
                            
                        }
                        
                        else if([msg isEqualToString:@"Error-422"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Unprocessable Entity. Please try again later."] sendViewController:self];
                        }
                        else if([msg isEqualToString:@"Error-404"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"The requested URL was not found on this server."] sendViewController:self];
                            
                        }
                        else if([msg isEqualToString:@"Error-405"] ||[msg isEqualToString:@"405"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"The requested URL was not found on this server."] sendViewController:self];
                            
                        }
                        else if([msg isEqualToString:@"Error-500"] ||[msg isEqualToString:@"500"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Internal Server Error.Something has gone wrong on the website's server."] sendViewController:self];
                            
                        }
                        
                        else{
                            
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                            [SVProgressHUD dismiss];
                        }
                        
                    }else if(error)  {
                        NSLog(@"Error is : %@",error);
                        
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-AllProbelms-Refresh-error == %@",error.localizedDescription);
                        
                        [SVProgressHUD dismiss];
                    }
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    
                    [self reload];
                    NSLog(@"Thread-call-Change Details");
                    return;
                }
                
                if ([msg isEqualToString:@"tokenNotRefreshed"]) {
                    
                    // [self showMessageForLogout:@"Your HELPDESK URL or Your Login credentials were changed, contact to Admin and please log back in." sendViewController:self];
                    
                    [SVProgressHUD dismiss];
                    
                    return;
                }
                
                
                if (json) {
                    
                    NSDictionary *problemList=[json objectForKey:@"data"];
                    
                    //subject data
                    NSString *subject= [problemList objectForKey:@"subject"];
                    
                    
                    if (![Utils isEmpty:subject] || ![subject isEqualToString:@""]){
                        
                        self->_subjectTextView.text = subject;
                    }
                    else  self->_subjectTextView.text = @"No data";
                    
                    //description data
                    NSString *description = [problemList objectForKey:@"description"];
                    
                    
                    if (![Utils isEmpty:description] || ![description isEqualToString:@""]){
                        
                        self->_descriptionTextView.text = description;
                    }
                    else self->_descriptionTextView.text = @"No data";
                    
                    //requester data
                    NSObject *requesterName= [problemList objectForKey:@"requester"];
                    
                    if([requesterName isKindOfClass:[NSNull class]]){
                        
                        self->_requesterTextField.text = @"No Requester Found";
                    }
                    else if([requesterName isKindOfClass:[NSDictionary class]]){
                        
                        NSDictionary *requesterDict= [problemList objectForKey:@"requester"];
                        
                        self->_requesterTextField.text = [NSString stringWithFormat:@"%@ %@",[requesterDict objectForKey:@"first_name"], [requesterDict objectForKey:@"last_name"]];
                        
                    }
                    else self->_requesterTextField.text = @"No Requester Found";
                    
                    
                    
                    //Impact data
                    NSDictionary *impactDict = [problemList objectForKey:@"impactType"];
                    
                    NSString * impactName = [impactDict objectForKey:@"name"];
                    [Utils isEmpty:impactName];
                    
                    if (![Utils isEmpty:impactName] || ![impactName isEqualToString:@""]){
                        
                        self->_impactTextField.text = impactName;
                    }
                    else self->_impactTextField.text = @"Not Found";
                    
                    
                    //status data
                    NSDictionary *statusDict = [problemList objectForKey:@"status"];
                    
                    
                    NSString * statusName = [statusDict objectForKey:@"name"];
                    
                    if (![Utils isEmpty:statusName] || ![statusName isEqualToString:@""]){
                        
                        self->_statusTextField.text = statusName;
                    }
                    else self->_statusTextField.text = @"Not Found";
                    
                    
                    // prority data
                    NSDictionary *priorityDict = [problemList objectForKey:@"priority"];
                    
                    
                    NSString * prioName = [priorityDict objectForKey:@"name"];
                    
                    
                    if (![Utils isEmpty:prioName] || ![prioName isEqualToString:@""]){
                        
                        self->_priorityTextField.text = prioName;
                    }
                    else self->_priorityTextField.text = @"Not Found";
                    
                    // change type data
                    NSDictionary *changeTypeDict = [problemList objectForKey:@"changeType"];
                    
                    
                    NSString * changeName = [changeTypeDict objectForKey:@"name"];
                    
                    
                    if (![Utils isEmpty:changeName] || ![changeName isEqualToString:@""]){
                        
                        self->_changeTextField.text = changeName;
                    }
                    else self->_changeTextField.text = @"Not Found";
                    
                    
                    //location
                    NSDictionary *locationDict = [problemList objectForKey:@"location"];
                    
                    if ( [locationDict count] == 0 ) {
                        
                        self->_locationTextField.text = @"Not Found";
                    }
                    else {
                        
                        NSString * locationName = [locationDict objectForKey:@"title"];
                        
                        if (![Utils isEmpty:locationName] || ![locationName isEqualToString:@""]){
                            
                            self->_locationTextField.text = locationName;
                        }
                        
                    }
                    
                    
                    [SVProgressHUD dismiss];
                }
                NSLog(@"Thread-change-detail-closed");
                
            }];
        }@catch (NSException *exception)
        {
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            [utils showAlertWithMessage:exception.name sendViewController:self];
            return;
        }
        @finally
        {
            NSLog( @" I am in reload method in getting change details ViewController" );
            
            
        }
    }
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

@end
