//
//  EditTicketDetails.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "EditTicketDetails.h"
#import "ActionSheetPicker.h"
#import "TicketDetailViewController.h"
#import "Utils.h"
#import "InboxTickets.h"
#import "MyWebservices.h"
#import "Reachability.h"
#import "GlobalVariables.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "UIColor+HexColors.h"
#import "SVProgressHUD.h"
#import "AppConstanst.h"
#import "LoginViewController.h"

@interface EditTicketDetails ()<RMessageProtocol>
{
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    NSString *AssignID;
    NSString *SourceID;
    
    NSNumber *type_id;
    NSNumber *help_topic_id;
    NSNumber *dept_id;
    NSNumber *priority_id;
    NSNumber *source_id;
    NSNumber *status_id;
    NSNumber *staff_id;
    
    
   
    NSMutableArray * type_idArray;
    NSMutableArray * dept_idArray;
    NSMutableArray * pri_idArray;
    NSMutableArray * helpTopic_idArray;
    NSMutableArray * status_idArray;
    NSMutableArray * source_idArray;
    NSMutableArray * staff_idArray;
    
    NSMutableArray * assignArray;
    
}

- (void)helpTopicWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)staffWasSelected:(NSNumber *)selectedIndex element:(id)element;

- (void)actionPickerCancelled:(id)sender;

@end

@implementation EditTicketDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Edit Ticket",nil)];
    
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    
    dept_id=[[NSNumber alloc]init];
    help_topic_id=[[NSNumber alloc]init];
    priority_id=[[NSNumber alloc]init];
    source_id=[[NSNumber alloc]init];
    status_id=[[NSNumber alloc]init];
    type_id=[[NSNumber alloc]init];
    staff_id=[[NSNumber alloc]init];
    
    assignArray = [[NSMutableArray alloc]init];
    
    UIToolbar *toolBar= [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *removeBtn=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done",nil) style:UIBarButtonItemStylePlain  target:self action:@selector(removeKeyBoard)];
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:space,removeBtn, nil]];
    [self.messageTextView setInputAccessoryView:toolBar];
    
    self.messageTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.messageTextView.layer.borderWidth = 0.4;
    self.messageTextView.layer.cornerRadius = 3;
    
    _saveButton.backgroundColor= [UIColor colorFromHexString:@"00aeef"];
     self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD showWithStatus:@"Loading details"];
    
    if([[userDefaults objectForKey:@"msgFromRefreshToken"] isEqualToString:@"Invalid credentials"])
    {
        NSString *msg=@"";
        [self showMessageForLogout:@"Access Denied.  Your credentials has been changed. Contact to Admin and try to login again." sendViewController:self];
        [self->userDefaults setObject:msg forKey:@"msgFromRefreshToken"];
        
        [SVProgressHUD dismiss];
    }
    else if([[userDefaults objectForKey:@"msgFromRefreshToken"] isEqualToString:@"API disabled"])
    {   NSString *msg=@"";
        [utils showAlertWithMessage:@"API is disabled in web, please enable it from Admin panel." sendViewController:self];
        [self->userDefaults setObject:msg forKey:@"msgFromRefreshToken"];
        [SVProgressHUD dismiss];
    }
    else if([[userDefaults objectForKey:@"msgFromRefreshToken"] isEqualToString:@"user"])
    {   NSString *msg=@"";
        
        [self showMessageForLogout:@"Your role has beed changed to user. Contact to your Admin and try to login again." sendViewController:self];
        [self->userDefaults setObject:msg forKey:@"msgFromRefreshToken"];
        [SVProgressHUD dismiss];
    }
    else if([[userDefaults objectForKey:@"msgFromRefreshToken"] isEqualToString:@"Methon not allowed"])
    {   NSString *msg=@"";
        [self showMessageForLogout:@"Your HELPDESK URL or Your Login credentials were changed, contact to Admin and please log back in." sendViewController:self];
        [self->userDefaults setObject:msg forKey:@"msgFromRefreshToken"];
        [SVProgressHUD dismiss];
    }
    else{
        
    [self reload];
    [self readFromPlist];
    
    }
    
}

-(void)removeKeyBoard
{
    [self.messageTextView resignFirstResponder];
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
                    [SVProgressHUD dismiss];
                    
                    [self->utils showAlertWithMessage:@"Error1" sendViewController:self];
                    NSLog(@"Thread-NO4-getDetail-Refresh-error == %@",error.localizedDescription);
                    
                    return ;
                }
                if (error || [msg containsString:@"Error"]) {
                    
                    [self.refreshControl endRefreshing];
                    [SVProgressHUD dismiss];
                    
                    if([msg isEqualToString:@"Error-422"])
                    {
                        NSLog(@"Message is : %@",msg);
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Unprocessable Entity. Please try again later."] sendViewController:self];
                    }
                    
                    else if([msg isEqualToString:@"Error-402"])
                    {
                        NSLog(@"Message is : %@",msg);
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access denied - Either your role has been changed or your login credential has been changed."] sendViewController:self];
                    }
                    
                    else if([msg isEqualToString:@"Error-500"] ||[msg isEqualToString:@"500"])
                    {
                        NSLog(@"Message is : %@",msg);
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Internal Server Error.Something has gone wrong on the website's server."] sendViewController:self];
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
                    
                    else if([msg isEqualToString:@"Error-400"] ||[msg isEqualToString:@"400"])
                    {
                        NSLog(@"Message is : %@",msg);
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"The request could not be understood by the server due to malformed syntax."] sendViewController:self];
                    }
                    
                    else if(error)  {
                        
                        NSLog(@"Error is : %@",error);
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
                
                if ([msg isEqualToString:@"tokenNotRefreshed"]) {
                    
                    [self->utils showAlertWithMessage:@"Your HELPDESK URL or Your Login credentials were changed, contact to Admin and please log back in." sendViewController:self];
                    
                    [SVProgressHUD dismiss];
                    
                    return;
                }
                
                if (json) {
                    //NSError *error;
                    
                    NSLog(@"Thread-NO4--getDetailAPI--%@",json);
                    
                    NSDictionary *dic= [json objectForKey:@"data"];
                    NSDictionary * ticketDict=[dic objectForKey:@"ticket"];
                    
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            self->globalVariables.ticketNumber=[ticketDict objectForKey:@"ticket_number"];
                            
                            if([NSNull null] != [ticketDict objectForKey:@"assignee"])
                            {
                                NSDictionary *assinee=[ticketDict objectForKey:@"assignee"];
                                
                                self->AssignID=[NSString stringWithFormat:@"%@", [assinee objectForKey:@"id"]];
                                
                                if([NSNull null] != [assinee objectForKey:@"first_name"])
                                {
                                    NSString * name= [NSString stringWithFormat:@"%@ %@",[assinee objectForKey:@"first_name"],[assinee objectForKey:@"last_name"]];
                                    
                                    self->_assigneeTextField.text=name;
                                    // _assinTextField.text= [dic objectForKey:@"assignee_email"];
                                }
                                else if([NSNull null] != [assinee objectForKey:@"email"])
                                {
                                    NSString * name=[assinee objectForKey:@"email"];
                                    
                                    self->_assigneeTextField.text=name;
                                    // _assinTextField.text= [dic objectForKey:@"assignee_email"];
                                }
                            }
                            else
                            {
                                self->_assigneeTextField.text=NSLocalizedString(@"Not Available",nil);
                                
                            }
                            
                            
                            //______________________________________________________________________________________________________
                            ////////////////for UTF-8 data encoding ///////
                            
                            NSString *encodedString =[ticketDict objectForKey:@"title"];
                            
                            
                            [Utils isEmpty:encodedString];
                            
                            if  ([Utils isEmpty:encodedString]){
                                //_subjectTextField.text =@"No Title";
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
                            
                            if (([[ticketDict objectForKey:@"type_name"] isEqual:[NSNull null]] ) || ( [[ticketDict objectForKey:@"type_name"] length] == 0 )) {
                                self->_typeTextField.text=NSLocalizedString(@"Not Available",nil);
                            }else self->_typeTextField.text=[ticketDict objectForKey:@"type_name"];
                            
                            if (([[ticketDict objectForKey:@"helptopic_name"] isEqual:[NSNull null]] ) || ( [[ticketDict objectForKey:@"helptopic_name"] length] == 0 )) {
                                self->_helptopicsTextField.text=NSLocalizedString(@"Not Available",nil);
                                
                            }else self->_helptopicsTextField.text=[ticketDict objectForKey:@"helptopic_name"];
                            
                            
                            if (([[ticketDict objectForKey:@"source_name"] isEqual:[NSNull null]] ) || ( [[ticketDict objectForKey:@"source_name"] length] == 0 )) {
                                self->_sourceTextField.text=NSLocalizedString(@"Not Available",nil);
                                
                            }else self->_sourceTextField.text=[ticketDict objectForKey:@"source_name"];
                            self->SourceID=[ticketDict objectForKey:@"source"];
                            
                            
                            if (([[ticketDict objectForKey:@"priority_name"] isEqual:[NSNull null]] ) || ( [[ticketDict objectForKey:@"priority_name"] length] == 0 )) {
                                self->_priorityTextField.text=NSLocalizedString(@"Not Available",nil);
                                
                            }else self->_priorityTextField.text=[ticketDict objectForKey:@"priority_name"];
                            
                            
                            [self.tableView reloadData];
                            [self.refreshControl endRefreshing];
                            [SVProgressHUD dismiss];
                            
                            
                            
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
            NSLog( @" I am in reload method in EditTicketDetail ViewController" );
            
        }
        
        
    }
}


-(void)readFromPlist{
    // Read plist from bundle and get Root Dictionary out of it
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"faveoData.plist"];
    
    @try{
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        {
            plistPath = [[NSBundle mainBundle] pathForResource:@"faveoData" ofType:@"plist"];
        }
        
      //  NSDictionary *resultDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        NSDictionary *resultDic = globalVariables.dependencyDataDict;
        
        NSLog(@"resultDic--%@",resultDic); 
        NSArray *deptArray=[resultDic objectForKey:@"departments"];
        NSArray *helpTopicArray=[resultDic objectForKey:@"helptopics"];
        NSArray *prioritiesArray=[resultDic objectForKey:@"priorities"];
        NSArray *sourcesArray=[resultDic objectForKey:@"sources"];
        NSMutableArray *staffsArray=[resultDic objectForKey:@"staffs"];
        NSArray *typeArray=[resultDic objectForKey:@"type"];
        
        //    NSLog(@"resultDic2--%@,%@,%@,%@,%@,%@,%@,%@",deptArray,helpTopicArray,prioritiesArray,slaArray,sourcesArray,staffsArray,statusArray,teamArray);
        
        NSMutableArray *deptMU=[[NSMutableArray alloc]init];
        NSMutableArray *helptopicMU=[[NSMutableArray alloc]init];
        NSMutableArray *priMU=[[NSMutableArray alloc]init];
        NSMutableArray *sourceMU=[[NSMutableArray alloc]init];
        NSMutableArray *typeMU=[[NSMutableArray alloc]init];
        NSMutableArray *staffMU=[[NSMutableArray alloc]init];
        
        
        dept_idArray=[[NSMutableArray alloc]init];
        helpTopic_idArray=[[NSMutableArray alloc]init];
        pri_idArray=[[NSMutableArray alloc]init];
        source_idArray=[[NSMutableArray alloc]init];
        type_idArray=[[NSMutableArray alloc]init];
        staff_idArray=[[NSMutableArray alloc]init];
        
        
        [staffMU insertObject:@"Select Assignee" atIndex:0];
        [staff_idArray insertObject:@"" atIndex:0];
        
        
        
        for (NSMutableDictionary *dicc in staffsArray) {
            if ([dicc objectForKey:@"email"]) {
                
                NSString * name= [NSString stringWithFormat:@"%@ %@",[dicc objectForKey:@"first_name"],[dicc objectForKey:@"last_name"]];
                
                // [staffMU insertObject:@"" atIndex:0]; // user_name
                //  [staffMU addObject:[dicc objectForKey:@"email"]];
                [Utils isEmpty:name];
                
                
                if  (![Utils isEmpty:name] )
                {
                    
                    [staffMU addObject:name];
                }
                else
                {
                    NSString * userName= [NSString stringWithFormat:@"%@",[dicc objectForKey:@"user_name"]];
                    [staffMU addObject:userName];
                }
                
                //  [staffMU addObject:name];
                [staff_idArray addObject:[dicc objectForKey:@"id"]];
                
            }
            
        }
        
        
        for (NSDictionary *dicc in deptArray) {
            if ([dicc objectForKey:@"name"]) {
                [deptMU addObject:[dicc objectForKey:@"name"]];
                [dept_idArray addObject:[dicc objectForKey:@"id"]];
            }
            
        }
        
        for (NSDictionary *dicc in prioritiesArray) {
            if ([dicc objectForKey:@"priority"]) {
                [priMU addObject:[dicc objectForKey:@"priority"]];
                [pri_idArray addObject:[dicc objectForKey:@"priority_id"]];
            }
            
        }
        
        
        for (NSDictionary *dicc in helpTopicArray) {
            if ([dicc objectForKey:@"topic"]) {
                [helptopicMU addObject:[dicc objectForKey:@"topic"]];
                [helpTopic_idArray addObject:[dicc objectForKey:@"id"]];
            }
        }
        
        for (NSDictionary *dicc in typeArray) {
            if ([dicc objectForKey:@"name"]) {
                [typeMU addObject:[dicc objectForKey:@"name"]];
                [type_idArray addObject:[dicc objectForKey:@"id"]];
            }
        }
        
        
        for (NSDictionary *dicc in sourcesArray) {
            if ([dicc objectForKey:@"name"]) {
                [sourceMU addObject:[dicc objectForKey:@"name"]];
                [source_idArray addObject:[dicc objectForKey:@"id"]];
            }
        }
        
    
        _deptArray=[deptMU copy];
        _helptopicsArray=[helptopicMU copy];
        _priorityArray=[priMU copy];
        _sourceArray=[sourceMU copy];
        _typeArray=[typeMU copy];
         assignArray=[staffMU copy];
        
        NSLog(@"Priority Array : %@",_priorityArray);
        NSLog(@"Helptopic Array : %@",_helptopicsArray);
        NSLog(@"source Array : %@",_sourceArray);
        NSLog(@"Type Array : %@",_typeArray);
        NSLog(@"Assignee Array : %@",assignArray);
        
//        _helptopicsArray = [_helptopicsArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//        _priorityArray = [_priorityArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//        _sourceArray = [_sourceArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//        _typeArray =  [_typeArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//        
        //[assignArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
    }@catch (NSException *exception)
    {
        [utils showAlertWithMessage:exception.name sendViewController:self];
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return;
    }
    @finally
    {
        NSLog( @" I am in readFromPList method in EditTIcketDetail ViewController" );
        
    }
    
    
}



- (IBAction)priorityClicked:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        [_priorityTextField resignFirstResponder];
        //[_subjectTextField resignFirstResponder];
        if (!_priorityArray||![_priorityArray count]) {
            _priorityTextField.text=NSLocalizedString(@"Not Available",nil);
            priority_id=0;
            
        }else{
            [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Priority",nil) rows:_priorityArray initialSelection:0 target:self successAction:@selector(priorityWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        [utils showAlertWithMessage:exception.name sendViewController:self];
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return;
    }
    @finally
    {
        NSLog( @" I am in priorityCLicked method in EditTicketDetail ViewController" );
        
    }
    
}

- (IBAction)helptopicClicked:(id)sender {
    
    @try{
            [self.view endEditing:YES];
            //[_subjectTextField resignFirstResponder];
            [_helptopicsTextField resignFirstResponder];
            if (!_helptopicsArray||!_helptopicsArray.count) {
                _helptopicsTextField.text=NSLocalizedString(@"Not Available",nil);
                help_topic_id=0;
            }else{
                [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Helptopic",nil) rows:_helptopicsArray initialSelection:0 target:self successAction:@selector(helpTopicWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
            }
        }@catch (NSException *exception)
        {
            [utils showAlertWithMessage:exception.name sendViewController:self];
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            return;
        }
        @finally
        {
            NSLog( @" I am in helpTopicCLicked method in EditTicketDteails ViewController" );
            
        }

}

- (IBAction)sourceClicked:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        // [_subjectTextField resignFirstResponder];
        [_sourceTextField resignFirstResponder];
        if (!_sourceArray||!_sourceArray.count) {
            _sourceTextField.text=NSLocalizedString(@"Not Available",nil);
            source_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Source",nil) rows:_sourceArray initialSelection:0 target:self successAction:@selector(sourceWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        [utils showAlertWithMessage:exception.name sendViewController:self];
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return;
    }
    @finally
    {
        NSLog( @" I am in spurceCLicked method in EditTicketDetail ViewController" );
        
    }
    
}

- (IBAction)typeClicked:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        [_typeTextField resignFirstResponder];
        if (!_typeArray||![_typeArray count]) {
            _typeTextField.text=NSLocalizedString(@"Not Available",nil);
            type_id=0;
            
        }else{
            [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Ticket Type",nil) rows:_typeArray initialSelection:0 target:self successAction:@selector(typeWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        [utils showAlertWithMessage:exception.name sendViewController:self];
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return;
    }
    @finally
    {
        NSLog( @" I am in typeClicked method in editTciketDetail ViewController" );
        
    }

    
    
}

- (IBAction)assigneeClicked:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        [_assigneeTextField resignFirstResponder];
        if (!assignArray||!assignArray.count) {
            _assigneeTextField.text=NSLocalizedString(@"Not Available",nil);
            staff_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Assignee",nil) rows:assignArray initialSelection:0 target:self successAction:@selector(staffWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        [utils showAlertWithMessage:exception.name sendViewController:self];
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return;
    }
    @finally
    {
        NSLog( @" I am in assignClicked method in EditTicketDetails ViewController" );
        
    }

}

- (void)sourceWasSelected:(NSNumber *)selectedIndex element:(id)element {
    source_id=(source_idArray)[(NSUInteger) [selectedIndex intValue]];
    // self.selectedIndex = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.sourceTextField.text = (_sourceArray)[(NSUInteger) [selectedIndex intValue]];
}
- (void)typeWasSelected:(NSNumber *)selectedIndex element:(id)element {
    type_id=(type_idArray)[(NSUInteger) [selectedIndex intValue]];
    // self.selectedIndex = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.typeTextField.text = (_typeArray)[(NSUInteger) [selectedIndex intValue]];
}

- (void)helpTopicWasSelected:(NSNumber *)selectedIndex element:(id)element {
    help_topic_id=(helpTopic_idArray)[(NSUInteger) [selectedIndex intValue]];
    // self.selectedIndex = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.helptopicsTextField.text = (_helptopicsArray)[(NSUInteger) [selectedIndex intValue]];
}

- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element {
    priority_id=(pri_idArray)[(NSUInteger) [selectedIndex intValue]];
    
    //self.selectedIndex = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.priorityTextField.text = (_priorityArray)[(NSUInteger) [selectedIndex intValue]];
}


- (void)staffWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    staff_id=(staff_idArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is : %@",staff_id);
    
    self.assigneeTextField.text = (assignArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"TextField value is : %@", _assigneeTextField.text);
}

- (void)actionPickerCancelled:(id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}



- (IBAction)saveButtonAction:(id)sender {
    
    if (self.messageTextView.text.length==0) {
        
        [self->utils showAlertWithMessage:NSLocalizedString(@"Alert: Please enter the subject field.", nil) sendViewController:self];
        
    }else if (self.helptopicsTextField.text.length==0) {
        
        [self->utils showAlertWithMessage:NSLocalizedString(@"Alert: Please select Helptopic.", nil) sendViewController:self];
    }else if (self.priorityTextField.text.length==0){
        
        [self->utils showAlertWithMessage:NSLocalizedString(@"Alert: Please select Priority.", nil) sendViewController:self];
    }else  if (self.sourceTextField.text.length==0){
        
        [self->utils showAlertWithMessage:NSLocalizedString(@"Alert: Please select the Ticket Source.", nil) sendViewController:self];
    }
//    if ([self.typeTextField.text isEqualToString:@"Not Available"]){
//
//        [self->utils showAlertWithMessage:NSLocalizedString(@"Alert: Please select the Ticket Type.", nil) sendViewController:self];
//    }
    else
    {
        [self save];
    }
    
}

// After clicking on submit/save button below method is called
-(void)save{
    
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
        
    }else{
        if (_typeTextField.text.length!=0) {
            
            if([_typeTextField.text isEqualToString:@"Not Available"]){
                type_id=0;
            }
            else{
            type_id=[NSNumber numberWithInteger:1+[_typeArray indexOfObject:_typeTextField.text]];
            }
        }else
        {
            type_id=0;
        
        }
        

        priority_id=[NSNumber numberWithInteger:1+[_priorityArray indexOfObject:_priorityTextField.text]];
        help_topic_id = [NSNumber numberWithInteger:1+[_helptopicsArray indexOfObject:_helptopicsTextField.text]];
       // sla_id = [NSNumber numberWithInteger:1+[_slaPlansArray indexOfObject:_slaTextField.text]];
        source_id = [NSNumber numberWithInteger:1+[_sourceArray indexOfObject:_sourceTextField.text]];
      //  status_id = [NSNumber numberWithInteger:1+[_statusArray indexOfObject:_statusTextField.text]];
        
        
        
        NSLog(@"Ticket Source is : %@",source_id);
        NSLog(@"Ticket Source is : %@",source_id);
        
        
        //  staff_id = [NSNumber numberWithInteger:1+[_assignArray indexOfObject:_assinTextField.text]];
        
       [SVProgressHUD showWithStatus:@"Saving data"];
        
        
        NSString *staffID= [NSString stringWithFormat:@"%@",staff_id];
        NSLog(@"stffId is : %@",staffID);
        NSLog(@"stffId is : %@",staffID);
        
        if (([_assigneeTextField.text isEqualToString:@"Not Available"])||([staffID isEqualToString:@""] && [_assigneeTextField.text isEqualToString:@"Select Assignee"]) || ([staffID isEqualToString:@""] || [_assigneeTextField.text isEqualToString:@"Select Assignee"]))
        {
            staffID=@"0";
        }
        else
            if (staffID == (id)[NSNull null] || staffID.length == 0 || staffID == nil || [staffID isEqualToString:@"(null)"])
            {
                staffID=AssignID;
                
                NSLog(@"Assssissisinne id : %@",AssignID);
                NSLog(@"Assssissisinne id : %@",AssignID);
                
                NSLog(@"IDDDDDDDD id : %@",staffID);
                NSLog(@"IDDDDDDDD id : %@",staffID);
            }
        
        
        NSString *url;
        
        if([_typeTextField.text isEqualToString:@"Not Available"]){
          
            url= [NSString stringWithFormat:@"%@helpdesk/edit?api_key=%@&ip=%@&token=%@&ticket_id=%@&help_topic=%@&ticket_priority=%@&ticket_source=%@&subject=%@&assigned=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],globalVariables.ticketId,help_topic_id,priority_id,source_id,_messageTextView.text,staffID];
            
            NSLog(@"URL is : %@",url);
            
        }
        else{
           
            url= [NSString stringWithFormat:@"%@helpdesk/edit?api_key=%@&ip=%@&token=%@&ticket_id=%@&help_topic=%@&ticket_type=%@&ticket_priority=%@&ticket_source=%@&subject=%@&assigned=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],globalVariables.ticketId,help_topic_id,type_id,priority_id,source_id,_messageTextView.text,staffID];
            
            NSLog(@"URL is : %@",url);
            
        }
       
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            
            [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
               
                
                if (error || [msg containsString:@"Error"]) {
                    
                    [SVProgressHUD dismiss];
                    
                    if (msg) {
                        
                        if([msg isEqualToString:@"Error-401"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access Denied.  Your credentials has been changed. Contact to Admin and try to login again."] sendViewController:self];
                        }
                        else
                            
                            if([msg isEqualToString:@"Error-403"])
                            {
                                [self->utils showAlertWithMessage:NSLocalizedString(@"Access Denied - You don't have permission.", nil) sendViewController:self];
                               
                            }
                            else if([msg isEqualToString:@"Error-403"] || [msg isEqualToString:@"403"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:@"Access Denied. Either your credentials has been changed or You are not an Agent/Admin." sendViewController:self];
                            }
                        
                        if([msg isEqualToString:@"Error-402"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access denied - Either your role has been changed or your login credential has been changed."] sendViewController:self];
                        }
                        
                        else{
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                        }
                        //  NSLog(@"Message is : %@",msg);
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self save];
                    NSLog(@"Thread--NO4-call-postCreateTicket");
                    return;
                }
                
                if (json) {
                    
                    
                    NSLog(@"JSON-CreateTicket-%@",json);
                    NSString *str= [json objectForKey:@"message"];
                    
                    if([str isEqualToString:@"Permission denied, you do not have permission to access the requested page."] || [str hasPrefix:@"Permission denied"])
                        
                    {
                        [SVProgressHUD dismiss];
                        
                        [self->utils showAlertWithMessage:NSLocalizedString(@"Access Denied - You don't have permission.", nil) sendViewController:self];
                    }else
                        
                    
                        if ([json objectForKey:@"result"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [SVProgressHUD dismiss];
                                
                                if (self.navigationController.navigationBarHidden) {
                                    [self.navigationController setNavigationBarHidden:NO];
                                }
                                
                                [RMessage showNotificationInViewController:self.navigationController
                                                                     title:NSLocalizedString(@"Done!", nil)
                                                                  subtitle:NSLocalizedString(@"Updated successfully..!", nil)
                                                                 iconImage:nil
                                                                      type:RMessageTypeSuccess
                                                            customTypeName:nil
                                                                  duration:RMessageDurationAutomatic
                                                                  callback:nil
                                                               buttonTitle:nil
                                                            buttonCallback:nil
                                                                atPosition:RMessagePositionNavBarOverlay
                                                      canBeDismissedByUser:YES];
                                
                                
                                InboxTickets *inboxVC=[self.storyboard instantiateViewControllerWithIdentifier:@"inboxId"];
                                [self.navigationController pushViewController:inboxVC animated:YES];
                                
                                
                            });
                            
                            
                        }else if([json objectForKey:@"response"])
                            
                        {
                            [SVProgressHUD dismiss];
                            
                            NSDictionary *dict1=[json objectForKey:@"response"];
                            NSString *msg= [dict1 objectForKey:@"message"];
                            
                            if([msg isEqualToString:@"Permission denied, you do not have permission to access the requested page."])
                                
                            {
                                [self->utils showAlertWithMessage:NSLocalizedString(@"Access Denied - You don't have permission.", nil) sendViewController:self];
                                
                            }
                            else
                                
                            {
                                [SVProgressHUD dismiss];
                                
                                if (self.navigationController.navigationBarHidden) {
                                    [self.navigationController setNavigationBarHidden:NO];
                                }
                                
                                [RMessage showNotificationInViewController:self.navigationController
                                                                     title:NSLocalizedString(@"Done!", nil)
                                                                  subtitle:NSLocalizedString(@"Updated successfully..!", nil)
                                                                 iconImage:nil
                                                                      type:RMessageTypeSuccess
                                                            customTypeName:nil
                                                                  duration:RMessageDurationAutomatic
                                                                  callback:nil
                                                               buttonTitle:nil
                                                            buttonCallback:nil
                                                                atPosition:RMessagePositionNavBarOverlay
                                                      canBeDismissedByUser:YES];
                                
                                
                                InboxTickets *inboxVC=[self.storyboard instantiateViewControllerWithIdentifier:@"inboxId"];
                                [self.navigationController pushViewController:inboxVC animated:YES];
                                
                            }
                            
                        }
                }
                NSLog(@"Thread-NO5-editTciketDetails-closed");
                
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
            NSLog( @" I am in saveButton method in EditTicketDetail ViewController" );
            
        }
        
        
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//This method the delegate if the specified text should be changed.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    
    {
        
        if([text isEqualToString:@" "])
        {
            if(!textView.text.length)
            {
                return NO;
            }
        }
        
        if([textView.text stringByReplacingCharactersInRange:range withString:text].length < textView.text.length)
        {
            
            return  YES;
        }
        
        if([textView.text stringByReplacingCharactersInRange:range withString:text].length >500)
        {
            return NO;
        }
        
        NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ./;@#$%&*,<-_"];
        
        
        if([text rangeOfCharacterFromSet:set].location == NSNotFound)
        {
            return NO;
        }
        
    }
    
    return YES;
}


//below 3 methods are used to logout a agent or admin when his login creadentials will change or there role will be changed or HELPDESL URL will change in these scenarious we have to move our from app so these 3 methods are used to achieve it.
-(void)showMessageForLogout:(NSString*)message sendViewController:(UIViewController *)viewController
{
    UIAlertController *alertController = [UIAlertController   alertControllerWithTitle:APP_NAME message:message  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction  actionWithTitle:@"Logout"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action)
                                   {
                                       [self logout];
                                       
                                       if (self.navigationController.navigationBarHidden) {
                                           [self.navigationController setNavigationBarHidden:NO];
                                       }
                                       
                                       [RMessage showNotificationInViewController:self.navigationController
                                                                            title:NSLocalizedString(@" Faveo Helpdesk ", nil)
                                                                         subtitle:NSLocalizedString(@"You've logged out, successfully...!", nil)
                                                                        iconImage:nil
                                                                             type:RMessageTypeSuccess
                                                                   customTypeName:nil
                                                                         duration:RMessageDurationAutomatic
                                                                         callback:nil
                                                                      buttonTitle:nil
                                                                   buttonCallback:nil
                                                                       atPosition:RMessagePositionNavBarOverlay
                                                             canBeDismissedByUser:YES];
                                       
                                       LoginViewController *login=[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
                                       [self.navigationController pushViewController: login animated:YES];
                                   }];
    [alertController addAction:cancelAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

-(void)logout
{
    
    [self sendDeviceToken];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    
    
}

-(void)sendDeviceToken{
    
    // NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *url=[NSString stringWithFormat:@"%@fcmtoken?user_id=%@&fcm_token=%s&os=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"user_id"],"0",@"ios"];
    
    
    MyWebservices *webservices=[MyWebservices sharedInstance];
    [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg){
        if (error || [msg containsString:@"Error"]) {
            if (msg) {
                
                // [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                NSLog(@"Thread-postAPNS-toserver-error == %@",error.localizedDescription);
            }else if(error)  {
                //                [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                NSLog(@"Thread-postAPNS-toserver-error == %@",error.localizedDescription);
            }
            return ;
        }
        if (json) {
            
            NSLog(@"Thread-sendAPNS-token-json-%@",json);
            //   [[AppDelegate sharedAppdelegate] hideProgressView];
            [SVProgressHUD dismiss];
        }
        
    }];
    
}

@end
