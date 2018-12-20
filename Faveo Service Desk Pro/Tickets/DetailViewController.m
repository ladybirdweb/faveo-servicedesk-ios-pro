//
//  DetailViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "DetailViewController.h"
#import "HexColors.h"
#import "Utils.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "GlobalVariables.h"
#import "IQKeyboardManager.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "SVProgressHUD.h"

@interface DetailViewController ()<RMessageProtocol>
{
    
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    

    self.messageTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.messageTextView.layer.borderWidth = 0.4;
    self.messageTextView.layer.cornerRadius = 3;
    
    [SVProgressHUD showWithStatus:@"Loading details"];
    [self reload];
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    _priorityTextField.userInteractionEnabled = NO;
    _helptopicTextField.userInteractionEnabled = NO;
    _nameTextField.userInteractionEnabled = NO;
    _ticketTypeTextField.userInteractionEnabled = NO;
    _assigneeTextField.userInteractionEnabled = NO;
    _dueDateTextField.userInteractionEnabled = NO;
    _createdTextField.userInteractionEnabled = NO;
    _lastResponseTextField.userInteractionEnabled = NO;
    _sourceTextField.userInteractionEnabled = NO;
    _emailTextField.userInteractionEnabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// This method calls an API for getting tickets, it will returns an JSON which contains 10 records with ticket details.
-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        
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
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/ticket?api_key=%@&ip=%@&token=%@&id=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],globalVariables.ticketId];
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                if (error) {
                    
                    [self->utils showAlertWithMessage:@"Error" sendViewController:self];
                    NSLog(@"Thread-NO4-getDetail-Refresh-error == %@",error.localizedDescription);
                    
                    return ;
                }
                if (error || [msg containsString:@"Error"]) {
                    
                    [self.refreshControl endRefreshing];
                    [SVProgressHUD dismiss];
                    
                    if (msg) {
                        
//                        if([msg isEqualToString:@"Error-401"])
//                        {
//                            NSLog(@"Message is : %@",msg);
//                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access Denied.  Your credentials has been changed. Contact to Admin and try to login again."] sendViewController:self];
//                        }
//                        else
                            
                            if([msg isEqualToString:@"Error-402"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"API is disabled in web, please enable it from Admin panel."] sendViewController:self];
                            }
                            else if([msg isEqualToString:@"Error-403"] || [msg isEqualToString:@"403"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:@"Access Denied. Either your credentials has been changed or You are not an Agent/Admin." sendViewController:self];
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
                            else if([msg isEqualToString:@"Error-400"] ||[msg isEqualToString:@"400"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"The request could not be understood by the server due to malformed syntax."] sendViewController:self];
                            }
                        
                            else{
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                            }
                        
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self reload];
                    NSLog(@"Thread--NO4-call-getDetail");
                    return;
                }
                
                if (json) {
                    //NSError *error;
                    NSLog(@"Thread-NO4--getDetailAPI--%@",json);
                    
                    NSDictionary *dic= [json objectForKey:@"data"];
                    NSDictionary * ticketDict=[dic objectForKey:@"ticket"];
                    
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            if([NSNull null] != [ticketDict objectForKey:@"created_at"])
                            {
                                self->_createdTextField.text= [self->utils getLocalDateTimeFromUTC:[ticketDict objectForKey:@"created_at"]];
                            }else
                            {
                                self->_createdTextField.text=NSLocalizedString(@"Not Available",nil);
                            }
                            
                            NSDictionary *userData=[ticketDict objectForKey:@"from"];
                            
                            if (([[userData objectForKey:@"first_name"] isEqual:[NSNull null]] ) || ( [[userData objectForKey:@"first_name"] length] == 0 )) {
                                self->_nameTextField.text=NSLocalizedString(@"Not Available",nil);
                            }else self->_nameTextField.text=[userData objectForKey:@"first_name"];
                            
                            
                            self->globalVariables.ticketNumber=[ticketDict objectForKey:@"ticket_number"];
                            //______________________________________________________________________________________________________
                            ////////////////for UTF-8 data encoding ///////
                            
                            NSString *encodedString =[ticketDict objectForKey:@"title"];
                            
                            
                            [Utils isEmpty:encodedString];
                            
                            if  ([Utils isEmpty:encodedString]){
                                // _subjectTextField.text =@"No Title";
                                self->_messageTextView.text= NSLocalizedString(@"Not Available",nil);
                            }
                            else
                            {
                                
                                NSMutableString *decodedString = [[NSMutableString alloc] init];
                                
                                if ([encodedString hasPrefix:@"=?UTF-8?Q?"] || [encodedString hasSuffix:@"?="])
                                {
                                    NSScanner *scanner = [NSScanner scannerWithString:encodedString];
                                    NSString *buf = nil;
                                    //  NSMutableString *decodedString = [[NSMutableString alloc] init];
                                    
                                    while ([scanner scanString:@"=?UTF-8?Q?" intoString:NULL]
                                           || ([scanner scanUpToString:@"=?UTF-8?Q?" intoString:&buf] && [scanner scanString:@"=?UTF-8?Q?" intoString:NULL])) {
                                        if (buf != nil) {
                                            [decodedString appendString:buf];
                                        }
                                        
                                        buf = nil;
                                        
                                        NSString *encodedRange;
                                        
                                        if (![scanner scanUpToString:@"?=" intoString:&encodedRange]) {
                                            break; // Invalid encoding
                                        }
                                        
                                        [scanner scanString:@"?=" intoString:NULL]; // Skip the terminating "?="
                                        
                                        // Decode the encoded portion (naively using UTF-8 and assuming it really is Q encoded)
                                        // I'm doing this really naively, but it should work
                                        
                                        // Firstly I'm encoding % signs so I can cheat and turn this into a URL-encoded string, which NSString can decode
                                        encodedRange = [encodedRange stringByReplacingOccurrencesOfString:@"%" withString:@"=25"];
                                        
                                        // Turn this into a URL-encoded string
                                        encodedRange = [encodedRange stringByReplacingOccurrencesOfString:@"=" withString:@"%"];
                                        
                                        
                                        // Remove the underscores
                                        encodedRange = [encodedRange stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                                        
                                        // [decodedString appendString:[encodedRange stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                        NSString *str1= [encodedRange stringByRemovingPercentEncoding];
                                        [decodedString appendString:str1];
                                        
                                        
                                    }
                                    
                                    NSLog(@"Decoded string = %@", decodedString);
                                    
                                    self->_messageTextView.text= decodedString;
                                }
                                else{
                                    
                                    self->_messageTextView.text= encodedString;
                                    
                                }
                                
                            }
                            ///////////////////////////////////////////////////
                            //____________________________________________________________________________________________________
                            
                            
                            if([NSNull null] != [userData objectForKey:@"email"])
                            {
                                self->_emailTextField.text=[userData objectForKey:@"email"];
                            }else
                            {
                                self->_emailTextField.text=NSLocalizedString(@"Not Available",nil);
                            }
                            
                            
                            if([NSNull null] != [ticketDict objectForKey:@"updated_at"])
                            {
                                self->_lastResponseTextField.text=[self->utils getLocalDateTimeFromUTC:[ticketDict objectForKey:@"updated_at"]];
                            }else
                            {
                                self->_lastResponseTextField.text=NSLocalizedString(@"Not Available",nil);
                            }
                            
                            
                            
                            
                            
                            if (([[ticketDict objectForKey:@"type_name"] isEqual:[NSNull null]] ) || ( [[ticketDict objectForKey:@"type_name"] length] == 0 )) {
                                self->_ticketTypeTextField.text= NSLocalizedString(@"Not Available",nil);
                            }else self->_ticketTypeTextField.text=[ticketDict objectForKey:@"type_name"];
                            
                            if (([[ticketDict objectForKey:@"helptopic_name"] isEqual:[NSNull null]] ) || ( [[ticketDict objectForKey:@"helptopic_name"] length] == 0 )) {
                                self->_helptopicTextField.text=NSLocalizedString(@"Not Available",nil);
                                
                            }else self->_helptopicTextField.text=[ticketDict objectForKey:@"helptopic_name"];
                            
                            
                            if (([[ticketDict objectForKey:@"source_name"] isEqual:[NSNull null]] ) || ( [[ticketDict objectForKey:@"source_name"] length] == 0 )) {
                                self->_sourceTextField.text=NSLocalizedString(@"Not Available",nil);
                                
                            }else self->_sourceTextField.text=[ticketDict objectForKey:@"source_name"];
                            
                            if (([[ticketDict objectForKey:@"priority_name"] isEqual:[NSNull null]] ) || ( [[ticketDict objectForKey:@"priority_name"] length] == 0 )) {
                                self->_priorityTextField.text=NSLocalizedString(@"Not Available",nil);
                                
                            }else self->_priorityTextField.text=[ticketDict objectForKey:@"priority_name"];
                            
                            
                            
                            
                            if([NSNull null] != [ticketDict objectForKey:@"assignee"])
                            {
                                NSDictionary *assinee=[ticketDict objectForKey:@"assignee"];
                                
                                
                                if (([[assinee objectForKey:@"email"] isEqual:[NSNull null]] ) || ( [[assinee objectForKey:@"email"] length] == 0 )) {
                                    
                                    self->_assigneeTextField.text=NSLocalizedString(@"Not Available",nil);
                                }else{
                                    NSString * name= [NSString stringWithFormat:@"%@ %@",[assinee objectForKey:@"first_name"],[assinee objectForKey:@"last_name"]];
                                    
                                    self->_assigneeTextField.text=name;
                                }
                                
                            }else
                            {
                                self->_assigneeTextField.text=NSLocalizedString(@"Not Available",nil);
                            }
                            
                            
                            if([NSNull null] != [ticketDict objectForKey:@"duedate"])
                            {
                                self->_dueDateTextField.text= [self->utils getLocalDateTimeFromUTCDueDate:[ticketDict objectForKey:@"duedate"]];
                            }else
                            {
                                self->_dueDateTextField.text=NSLocalizedString(@"Not Available",nil);
                            }
                            //  self->_dueDateTextField.text= [self->utils getLocalDateTimeFromUTC:[ticketDict objectForKey:@"duedate"]];
                            
                            
                            [self.refreshControl endRefreshing];
                            [SVProgressHUD dismiss];
                            
                            [self.tableView reloadData];
                            
                        });
                    });
                }
                
                NSLog(@"Thread-NO5-getDetail-closed");
                
            }];
        }@catch (NSException *exception)
        {
            [utils showAlertWithMessage:exception.name sendViewController:self];
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            [SVProgressHUD dismiss];
            return;
        }
        @finally
        {
            NSLog( @" I am in reload method in TicketDetailView ViewController" );
            
        }
        
        
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

//This method the delegate if the specified text should be changed.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
   
    
    return NO;
    
//    if(textField==_helptopicTextField)
//    {
//        return NO;
//    }
//
//    if(textField==_ticketTypeTextField)
//    {
//        return NO;
//    }
//
//    if(textField==_priorityTextField)
//    {
//        return NO;
//    }
//
//    if(textField==_assigneeTextField)
//    {
//        return NO;
//    }
//
//
//    return YES;
}



@end
