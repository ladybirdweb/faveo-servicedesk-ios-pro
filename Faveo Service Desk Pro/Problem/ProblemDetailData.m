//
//  ProblemDetailData.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ProblemDetailData.h"
#import "AnalysisView.h"
#import "Utils.h"
#import "MyWebservices.h"
#import "GlobalVariables.h"
#import "SVProgressHUD.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "Reachability.h"
#import "ProblemDetailView.h"
#import "UIColor+HexColors.h"
#import "HexColors.h"


@interface ProblemDetailData ()<UITextFieldDelegate>
{
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
}
@end

@implementation ProblemDetailData

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    
    //problem subject textview
    self.problemSubject.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.problemSubject.layer.borderWidth = 0.4;
    self.problemSubject.layer.cornerRadius = 3;
  
    //problem desc textview
    self.problemDescription.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.problemDescription.layer.borderWidth = 0.4;
    self.problemDescription.layer.cornerRadius = 3;
    
    
    _problemSubject.userInteractionEnabled = NO;
    _problemDescription.userInteractionEnabled = NO;
    _fromTextField.userInteractionEnabled = NO;
    _statusTextField.userInteractionEnabled = NO;
    _priorityTextField.userInteractionEnabled = NO;
    _locationTextField.userInteractionEnabled = NO;
    _sourceTextField.userInteractionEnabled = NO;
    _assigneeTextField.userInteractionEnabled = NO;
    _departmentTextField.userInteractionEnabled = NO;
    _impactTextField.userInteractionEnabled = NO;
   // _assetsTextField.userInteractionEnabled = NO;
    
    
    
    
    
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
        
        
        NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/problem/editbind/%@?token=%@",[userDefaults objectForKey:@"baseURL"],globalVariables.problemId,[userDefaults objectForKey:@"token"]];
        
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
                    NSLog(@"Thread-call-getAllProblems");
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
                        
                        self->_problemSubject.text = subject;
                    }
                    else  self->_problemSubject.text = @"Not Available";
                
                    //description data
                    NSString *description = [problemList objectForKey:@"description"];
                   
                    
                    if (![Utils isEmpty:description] || ![description isEqualToString:@""]){
                        
                        self->_problemDescription.text = description;
                    }
                    else self->_problemDescription.text = @"Not Available";
                    
                    //from data
                    NSString *from= [problemList objectForKey:@"from"];
                    
                    
                    if (![Utils isEmpty:from] || ![from isEqualToString:@""]){
                        
                        self->_fromTextField.text = from;
                    }
                    else self->_fromTextField.text = @"Not Available";
                    
                    
                    //department data
                    NSDictionary *deptDict= [problemList objectForKey:@"department"];

                 //   NSString * deptId = [deptDict objectForKey:@"id"];

                    NSString * deptName = [deptDict objectForKey:@"name"];
                    [Utils isEmpty:deptName];

                    if (![Utils isEmpty:deptName] || ![deptName isEqualToString:@""]){

                        self->_departmentTextField.text = deptName;
                    }
                    else self->_departmentTextField.text = @"Not Available";

                    
                    //Impact data
                    NSDictionary *impactDict = [problemList objectForKey:@"impact_id"];

                  //  NSString * impactId = [impactDict objectForKey:@"id"];

                    NSString * impactName = [impactDict objectForKey:@"name"];
                    [Utils isEmpty:impactName];

                    if (![Utils isEmpty:impactName] || ![impactName isEqualToString:@""]){

                        self->_impactTextField.text = impactName;
                    }
                    else self->_impactTextField.text = @"Not Available";
                    
                    
                    //stastus data
                    NSDictionary *statusDict = [problemList objectForKey:@"status_type_id"];
                    
                 //   NSString * statusId = [statusDict objectForKey:@"id"];
                    
                    NSString * statusName = [statusDict objectForKey:@"name"];
                  
                    if (![Utils isEmpty:statusName] || ![statusName isEqualToString:@""]){
                        
                        self->_statusTextField.text = statusName;
                    }
                    else self->_statusTextField.text = @"Not Available";
                    
                    
                    // prority data
                    NSDictionary *priorityDict = [problemList objectForKey:@"priority_id"];
                    
                   // NSString * prioId = [priorityDict objectForKey:@"priority_id"];
                    NSString * prioName = [priorityDict objectForKey:@"priority"];
                   
                    
                    if (![Utils isEmpty:prioName] || ![prioName isEqualToString:@""]){
                        
                        self->_priorityTextField.text = prioName;
                    }
                    else self->_priorityTextField.text = @"Not Available";
                    
                    
                    NSDictionary *locationDict = [problemList objectForKey:@"location_type_id"];
                    
                   // NSString * locationId = [locationDict objectForKey:@"id"];
                   
                    if ( [locationDict count] == 0 ) {
                        
                        self->_locationTextField.text = @"Not Available";
                    }
                    else {
                        
                        NSString * locationName = [locationDict objectForKey:@"title"];
                        
                        if (![Utils isEmpty:locationName] || ![locationName isEqualToString:@""]){
                            
                            self->_locationTextField.text = locationName;
                        }
                        
                    }
                    
                    
                  /*  //assets
                    NSDictionary *assetsDict = [problemList objectForKey:@"assets"];
                    
                    if ( [assetsDict count] == 0 ) {
                        
                        self->_assetsTextField.text = @"No data";
                    }
                    else {
                        
                        NSString * assetName = [assetsDict objectForKey:@"name"];
                        
                        if (![Utils isEmpty:assetName] || ![assetName isEqualToString:@""]){
                            
                            self->_assetsTextField.text = assetName;
                        }
                        
                    }
                    */
                    
                    
                   NSDictionary *assigneeDict = [problemList objectForKey:@"assigned_id"];
                  
                    if ( [assigneeDict count] == 0 ) {
                        
                        self->_assigneeTextField.text = @"No Assignee";
                    }
                    else {
                        
                        NSString * assigneeName;// =[NSString stringWithFormat:@"%@"]; //[assigneeDict objectForKey:@"first_name"];
                        
                        if (![Utils isEmpty:[assigneeDict objectForKey:@"first_name"]] && ![Utils isEmpty:[assigneeDict objectForKey:@"last_name"]] ){
                            
                            assigneeName = [NSString stringWithFormat:@"%@ %@",[assigneeDict objectForKey:@"first_name"],[assigneeDict objectForKey:@"last_name"]];
                        }
                        else{
                            
                            assigneeName= [NSString stringWithFormat:@"%@",[assigneeDict objectForKey:@"user_name"]];
                        }

                        if (![Utils isEmpty:assigneeName] || ![assigneeName isEqualToString:@""]){
                            
                            self->_assigneeTextField.text = assigneeName;
                        }
                        
                    }
                    
                    
                    [SVProgressHUD dismiss];
                }
                NSLog(@"Thread-probel-detail-closed");
                
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
            NSLog( @" I am in reload method in Inbox ViewController" );
            
            
        }
    }
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

@end
