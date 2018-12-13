//
//  EditProblemDetails.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "EditProblemDetails.h"
#import "SVProgressHUD.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "Reachability.h"
#import "GlobalVariables.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "Utils.h"
#import "ActionSheetStringPicker.h"
#import "ProblemList.h"

@interface EditProblemDetails ()<RMessageProtocol,UITextFieldDelegate,UITextViewDelegate>
{
    
    NSString *AssignID;
    
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    NSNumber *from_id;
    NSNumber *department_id;
    NSNumber *impact_id;
    NSNumber *status_id;
    NSNumber *location_id;
    NSNumber *priority_id;
    NSNumber *assigned_id;
    NSNumber *asset_id;
    
    NSMutableArray * from_idArray;
    NSMutableArray * department_idArray;
    NSMutableArray * impact_idArray;
    NSMutableArray * status_idArray;
    NSMutableArray * location_idArray;
    NSMutableArray * priority_idArray;
    NSMutableArray * assigned_idArray;
    NSMutableArray * asset_idArray;
    
    NSString * assetIds;
    
}

- (void)fromWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)departmentWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)impactWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)statusWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)locationWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)assigneeWasSelected:(NSNumber *)selectedIndex element:(id)element;
//- (void)assetWasSelected:(NSNumber *)selectedIndex element:(id)element;

- (void)actionPickerCancelled:(id)sender;


@end

@implementation EditProblemDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    utils=[[Utils alloc]init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalVariables=[GlobalVariables sharedInstance];
    
    
    _fromArray=[[NSMutableArray alloc]init];
    _departmentArray=[[NSMutableArray alloc]init];
    _impactArray=[[NSMutableArray alloc]init];
    _statusArray=[[NSMutableArray alloc]init];
    _locationArray=[[NSMutableArray alloc]init];
    _priorityArray=[[NSMutableArray alloc]init];
    _assignedArray=[[NSMutableArray alloc]init];
    _assetArray=[[NSMutableArray alloc]init];
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"Please wait"];
    [self reload];
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getMetaDataForProblem];
}



-(void)getMetaDataForProblem{
    
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
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
        
        NSString *url=[NSString stringWithFormat:@"%@servicedesk/dependency?type=problem&token=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"token"]];
        
        //   NSLog(@"URL is : %@",url);
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg){
                
                
                if (error || [msg containsString:@"Error"]) {
                    
                    [SVProgressHUD dismiss];
                    
                        if( [msg containsString:@"Error-429"])
                            
                        {
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"your request counts exceed our limit"] sendViewController:self];
                            
                            
                        }
                    
                        else if( ([msg isEqualToString:@"Error-403"] && [self->globalVariables.roleFromAuthenticateAPI isEqualToString:@"user"] ) || ([msg isEqualToString:@"Error-403"] || [self->globalVariables.roleFromAuthenticateAPI isEqualToString:@"user"]))
                            
                        {
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access Denied.  Your credentials/Role has been changed. Contact to Admin and try to login again."] sendViewController:self];
                            
                            
                        }
                    
                        else if([msg isEqualToString:@"Error-404"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"The requested URL was not found on this server."] sendViewController:self];
                            
                        }
                    
                    
                        else{
                            NSLog(@"Error message is %@",msg);
                            //   NSLog(@"Thread-NO4-getdependency-Refresh-error == %@",error.localizedDescription);
                            if([error.localizedDescription isEqualToString:@"The request timed out."])
                            {
                                [self->utils showAlertWithMessage:@"The request timed out" sendViewController:self];
                            }else
                                
                                [self->utils showAlertWithMessage:error.localizedDescription sendViewController:self];
                            [SVProgressHUD dismiss];
                            
                            return ;
                        }
                }
                
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self getMetaDataForProblem];
                    
                    NSLog(@"Thread-problem-dependency");
                    return;
                }
                
                if ([msg isEqualToString:@"tokenNotRefreshed"]) {
                    
                    //  [self showMessageForLogout:@"Your HELPDESK URL or Your Login credentials were changed, contact to Admin and please log back in." sendViewController:self];
                    
                    //  [[AppDelegate sharedAppdelegate] hideProgressView];
                    [SVProgressHUD dismiss];
                    
                    return;
                }
                if (json) {
                    
                    //NSLog(@"Thread-getproblems-dependency : %@",json);
                    NSArray *fromArray = [json objectForKey:@"from"]; //NSLog(@"%@",fromArray);
                    NSArray *departmentArray = [json objectForKey:@"departments"];
                    NSArray *impactArray = [json objectForKey:@"impact_ids"];
                    NSArray *statusArray = [json objectForKey:@"status_type_ids"];
                    NSArray *locationArray = [json objectForKey:@"location"];
                    NSArray *priorityArray = [json objectForKey:@"priority_ids"];
                    NSArray *assigneeArray = [json objectForKey:@"assigned_ids"];
                    NSArray *assetsArray = [json objectForKey:@"assets"];
                    
                    
                    NSMutableArray *fromMU=[[NSMutableArray alloc]init];
                    NSMutableArray *departmentMU=[[NSMutableArray alloc]init];
                    NSMutableArray *impactMU=[[NSMutableArray alloc]init];
                    NSMutableArray *statusMU=[[NSMutableArray alloc]init];
                    NSMutableArray *locationMU=[[NSMutableArray alloc]init];
                    NSMutableArray *priorityMU=[[NSMutableArray alloc]init];
                    NSMutableArray *assigneeMU=[[NSMutableArray alloc]init];
                    NSMutableArray *assetsMU=[[NSMutableArray alloc]init];
                    
                    
                    self->from_id=[[NSNumber alloc]init];
                    self->department_id=[[NSNumber alloc]init];
                    self->impact_id=[[NSNumber alloc]init];
                    self->status_id=[[NSNumber alloc]init];
                    self->location_id=[[NSNumber alloc]init];
                    self->priority_id=[[NSNumber alloc]init];
                    self->assigned_id=[[NSNumber alloc]init];
                    self->asset_id=[[NSNumber alloc]init];
                    
                    self->from_idArray =[[NSMutableArray alloc]init];
                    self->department_idArray =[[NSMutableArray alloc]init];
                    self->impact_idArray =[[NSMutableArray alloc]init];
                    self->status_idArray =[[NSMutableArray alloc]init];
                    self->location_idArray =[[NSMutableArray alloc]init];
                    self->priority_idArray =[[NSMutableArray alloc]init];
                    self->assigned_idArray =[[NSMutableArray alloc]init];
                    self->asset_idArray =[[NSMutableArray alloc]init];
                    
                    
                    
                    
                    
                    
                    for (NSMutableDictionary *dicc in fromArray) {
                        
                        if ([dicc objectForKey:@"email"]) {
                            
                            NSString * name= [NSString stringWithFormat:@"%@ %@",[dicc objectForKey:@"first_name"],[dicc objectForKey:@"last_name"]];
                            
                            
                            [Utils isEmpty:name];
                            
                            
                            if  (![Utils isEmpty:name] )
                            {
                                
                                [fromMU addObject:name];
                            }
                            else
                            {
                                NSString * userName= [NSString stringWithFormat:@"%@",[dicc objectForKey:@"user_name"]];
                                [fromMU addObject:userName];
                            }
                            
                            //  [staffMU addObject:name];
                            [self->from_idArray addObject:[dicc objectForKey:@"email"]];
                            
                        }
                        
                    }
                    
                    for (NSMutableDictionary *dicc in assigneeArray) {
                        
                        if ([dicc objectForKey:@"email"]) {
                            
                            NSString * name= [NSString stringWithFormat:@"%@ %@",[dicc objectForKey:@"first_name"],[dicc objectForKey:@"last_name"]];
                            
                            
                            [Utils isEmpty:name];
                            
                            
                            if  (![Utils isEmpty:name] )
                            {
                                
                                [assigneeMU addObject:name];
                            }
                            else
                            {
                                NSString * userName= [NSString stringWithFormat:@"%@",[dicc objectForKey:@"user_name"]];
                                [assigneeMU addObject:userName];
                            }
                            
                            //  [staffMU addObject:name];
                            [self->assigned_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                        
                    }
                    
                    
                    
                    for (NSDictionary *dicc in departmentArray) {
                        if ([dicc objectForKey:@"name"]) {
                            [departmentMU addObject:[dicc objectForKey:@"name"]];
                            [self->department_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    for (NSDictionary *dicc in impactArray) {
                        if ([dicc objectForKey:@"name"]) {
                            [impactMU addObject:[dicc objectForKey:@"name"]];
                            [self->impact_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    for (NSDictionary *dicc in statusArray) {
                        if ([dicc objectForKey:@"name"]) {
                            [statusMU addObject:[dicc objectForKey:@"name"]];
                            [self->status_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    
                    for (NSDictionary *dicc in locationArray) {
                        if ([dicc objectForKey:@"title"]) {
                            [locationMU addObject:[dicc objectForKey:@"title"]];
                            [self->location_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    for (NSDictionary *dicc in priorityArray) {
                        if ([dicc objectForKey:@"priority"]) {
                            [priorityMU addObject:[dicc objectForKey:@"priority"]];
                            [self->priority_idArray addObject:[dicc objectForKey:@"priority_id"]];
                            
                        }
                    }
                    
                    for (NSDictionary *dicc in assetsArray) {
                        if ([dicc objectForKey:@"name"]) {
                            [assetsMU addObject:[dicc objectForKey:@"name"]];
                            [self->asset_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    
                    self->_fromArray=[fromMU copy];
                    self->_departmentArray=[departmentMU copy];
                    self->_impactArray=[impactMU copy];
                    self->_statusArray=[statusMU copy];
                    self->_locationArray=[locationMU copy];
                    self->_priorityArray=[priorityMU copy];
                    self->_assignedArray=[assigneeMU copy];
                    self->_assetArray=[assetsMU copy];
                    
                    
                }
                NSLog(@"Thread-allproblem-dependency-closed");
            }
             ];
        }@catch (NSException *exception)
        {
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            [utils showAlertWithMessage:exception.name sendViewController:self];
            [SVProgressHUD dismiss];
            return;
        }
        @finally
        {
            NSLog( @" I am in get all problems method in All Problems" );
            
            
        }
    }
    
    
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
                        
                        self->_subjectTextView.text = subject;
                    }
                    else  self->_subjectTextView.text = @"No data";
                    
                    //description data
                    NSString *description = [problemList objectForKey:@"description"];
                    
                    
                    if (![Utils isEmpty:description] || ![description isEqualToString:@""]){
                        
                        self->_descriptionTextView.text = description;
                    }
                    else self->_descriptionTextView.text = @"No data";
                    
                    //from data
                    NSString *from= [problemList objectForKey:@"from"];
                    
                    
                    if (![Utils isEmpty:from] || ![from isEqualToString:@""]){
                        
                        self->_fromTextField.text = from;
                    }
                    else self->_fromTextField.text = @"No data";
                    
                    
                    //department data
                    NSDictionary *deptDict= [problemList objectForKey:@"department"];
                    
                    //   NSString * deptId = [deptDict objectForKey:@"id"];
                    
                    NSString * deptName = [deptDict objectForKey:@"name"];
                    [Utils isEmpty:deptName];
                    
                    if (![Utils isEmpty:deptName] || ![deptName isEqualToString:@""]){
                        
                        self->_departmentTextField.text = deptName;
                    }
                    else self->_departmentTextField.text = @"No data";
                    
                    
                    //Impact data
                    NSDictionary *impactDict = [problemList objectForKey:@"impact_id"];
                    
                    //  NSString * impactId = [impactDict objectForKey:@"id"];
                    
                    NSString * impactName = [impactDict objectForKey:@"name"];
                    [Utils isEmpty:impactName];
                    
                    if (![Utils isEmpty:impactName] || ![impactName isEqualToString:@""]){
                        
                        self->_impactTextField.text = impactName;
                    }
                    else self->_impactTextField.text = @"No data";
                    
                    
                    //stastus data
                    NSDictionary *statusDict = [problemList objectForKey:@"status_type_id"];
                    
                    //   NSString * statusId = [statusDict objectForKey:@"id"];
                    
                    NSString * statusName = [statusDict objectForKey:@"name"];
                    
                    if (![Utils isEmpty:statusName] || ![statusName isEqualToString:@""]){
                        
                        self->_statusTextField.text = statusName;
                    }
                    else self->_statusTextField.text = @"No data";
                    
                    
                    // prority data
                    NSDictionary *priorityDict = [problemList objectForKey:@"priority_id"];
                    
                    // NSString * prioId = [priorityDict objectForKey:@"priority_id"];
                    NSString * prioName = [priorityDict objectForKey:@"priority"];
                    
                    
                    if (![Utils isEmpty:prioName] || ![prioName isEqualToString:@""]){
                        
                        self->_priorityTextField.text = prioName;
                    }
                    else self->_priorityTextField.text = @"No data";
                    
                    
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
                    
                   // assignee data
                 NSDictionary *assigneeDict = [problemList objectForKey:@"assigned_id"];
                   
                    if ( [assigneeDict count] == 0 ) {
                        
                        self->_assigneeTextField.text = @"Not Available";
                    }
                    else {
                        
                    NSString * name =[NSString stringWithFormat:@"%@ %@",[assigneeDict objectForKey:@"first_name"],[assigneeDict objectForKey:@"last_name"]];
                        
                    if (![Utils isEmpty:name] || ![name isEqualToString:@""]){
                        
                    
                      self->_assigneeTextField.text = name;
                    
                    }
                
                    }
                    
//                    //assets
//                    NSDictionary *assetsDict = [problemList objectForKey:@"assets"];
//                    
//                    if ( [assetsDict count] == 0 ) {
//                        
//                        self->_assetsTextField.text = @"No data";
//                    }
//                    else {
//                        
//                        NSString * assetName = [assetsDict objectForKey:@"name"];
//                        
//                        if (![Utils isEmpty:assetName] || ![assetName isEqualToString:@""]){
//                            
//                            self->_assetsTextField.text = assetName;
//                        }
//                        
//                    }
                    
                    
                    
                    
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


- (IBAction)fromTextFieldClicked:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_fromArray||!_fromArray.count) {
            _fromTextField.text=NSLocalizedString(@"Not Available",nil);
            from_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Requester" rows:_fromArray initialSelection:0 target:self successAction:@selector(fromWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        [utils showAlertWithMessage:exception.name sendViewController:self];
        return;
    }
    @finally
    {
        NSLog( @" I am in HelptopicCLicked method in CreateTicket ViewController" );
        
    }
    
}

- (IBAction)impactTextFieldClicked:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_impactArray||!_impactArray.count) {
            _impactTextField.text=NSLocalizedString(@"Not Available",nil);
            from_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Impact" rows:_impactArray initialSelection:0 target:self successAction:@selector(impactWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        [utils showAlertWithMessage:exception.name sendViewController:self];
        return;
    }
    @finally
    {
        NSLog( @" I am in HelptopicCLicked method in CreateTicket ViewController" );
        
    }
    
}

- (IBAction)statusTextFieldClicked:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_statusArray||!_statusArray.count) {
            _statusTextField.text=NSLocalizedString(@"Not Available",nil);
            from_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Status" rows:_statusArray initialSelection:0 target:self successAction:@selector(statusWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        [utils showAlertWithMessage:exception.name sendViewController:self];
        return;
    }
    @finally
    {
        NSLog( @" I am in HelptopicCLicked method in CreateTicket ViewController" );
        
    }
    
}


- (IBAction)priorityTextFieldClicked:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_priorityArray||!_priorityArray.count) {
            _priorityTextField.text=NSLocalizedString(@"Not Available",nil);
            from_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Priority" rows:_priorityArray initialSelection:0 target:self successAction:@selector(priorityWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        [utils showAlertWithMessage:exception.name sendViewController:self];
        return;
    }
    @finally
    {
        NSLog( @" I am in HelptopicCLicked method in CreateTicket ViewController" );
        
    }
    
}

- (IBAction)departmentTextFieldClicked:(id)sender {
    
    
    @try{
        [self.view endEditing:YES];
        if (!_departmentArray||!_departmentArray.count) {
            _departmentTextField.text=NSLocalizedString(@"Not Available",nil);
            from_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Department" rows:_departmentArray initialSelection:0 target:self successAction:@selector(departmentWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        [utils showAlertWithMessage:exception.name sendViewController:self];
        return;
    }
    @finally
    {
        NSLog( @" I am in HelptopicCLicked method in CreateTicket ViewController" );
        
    }
    
}

- (IBAction)locationTextFieldClicked:(id)sender {
    
    
    @try{
        [self.view endEditing:YES];
        if (!_locationArray||!_locationArray.count) {
            _locationTextField.text=NSLocalizedString(@"Not Available",nil);
            from_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Location" rows:_locationArray initialSelection:0 target:self successAction:@selector(locationWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        [utils showAlertWithMessage:exception.name sendViewController:self];
        return;
    }
    @finally
    {
        NSLog( @" I am in HelptopicCLicked method in CreateTicket ViewController" );
        
    }
    
    
}

- (IBAction)assigneeTextFieldClicked:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_assignedArray||!_assignedArray.count) {
            _assigneeTextField.text=NSLocalizedString(@"Not Available",nil);
            from_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Assignee" rows:_assignedArray initialSelection:0 target:self successAction:@selector(assigneeWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        [utils showAlertWithMessage:exception.name sendViewController:self];
        return;
    }
    @finally
    {
        NSLog( @" I am in HelptopicCLicked method in CreateTicket ViewController" );
        
    }
    
}

//- (IBAction)assetsTextFieldClicked:(id)sender {
//
//   // NSLog(@"Assets are: %@",_assetArray);
//
//    @try{
//        [self.view endEditing:YES];
//        if (!_assetArray || !_assetArray.count) {
//            _assetsTextField.text=NSLocalizedString(@"Not Available",nil);
//            from_id=0;
//        }else{
//            [ActionSheetStringPicker showPickerWithTitle:@"Select Assets" rows:_assetArray initialSelection:0 target:self successAction:@selector(assetWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//        }
//    }@catch (NSException *exception)
//    {
//        NSLog( @"Name: %@", exception.name);
//        NSLog( @"Reason: %@", exception.reason );
//        [utils showAlertWithMessage:exception.name sendViewController:self];
//        return;
//    }
//    @finally
//    {
//        NSLog( @" I am in Add Assets method in CreateProblem ViewController" );
//
//    }
//
//}

- (void)actionPickerCancelled:(id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}


- (void)fromWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    
    
    from_id=(from_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.fromTextField.text = (_fromArray)[(NSUInteger) [selectedIndex intValue]];
    
    NSLog(@"Id is: %@",from_id); // it is getting email e.g  Id is: alokjena@gmail.com
    NSLog(@"From is: %@",_fromTextField.text);
    
}
- (void)departmentWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    department_id=(department_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.departmentTextField.text = (_departmentArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",department_id);
    NSLog(@"From is: %@",_departmentTextField.text);
}
- (void)impactWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    impact_id=(impact_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.impactTextField.text = (_impactArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",impact_id);
    NSLog(@"From is: %@",_impactTextField.text);
    
    
}
- (void)statusWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    status_id=(status_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.statusTextField.text = (_statusArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",status_id);
    NSLog(@"From is: %@",_statusTextField.text);
    
}
- (void)locationWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    location_id=(location_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.locationTextField.text = (_locationArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",location_id);
    NSLog(@"From is: %@",_locationTextField.text);
    
}
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    priority_id=(priority_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.priorityTextField.text = (_priorityArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",priority_id);
    NSLog(@"From is: %@",_priorityTextField.text);
    
}
- (void)assigneeWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    assigned_id=(assigned_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.assigneeTextField.text = (_assignedArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",assigned_id);
    NSLog(@"From is: %@",_assigneeTextField.text);
}


//- (void)assetWasSelected:(NSNumber *)selectedIndex element:(id)element{
//
//    asset_id=(asset_idArray)[(NSUInteger) [selectedIndex intValue]];
//    self.assetsTextField.text = (_assetArray)[(NSUInteger) [selectedIndex intValue]];
//    NSLog(@"Id is: %@",asset_id);
//    NSLog(@"From is: %@",_assetsTextField.text);
//}


- (IBAction)submitButtonClicked:(id)sender {
    
    
    [SVProgressHUD showWithStatus:@"Please wait"];
    
    
    if(self.subjectTextView.text.length==0 || self.descriptionTextView.text.length==0 || self.fromTextField.text.length==0 || self.impactTextField.text.length==0 || self.statusTextField.text.length==0 || self.priorityTextField.text.length==0 || self.departmentTextField.text.length==0 )
    {
        [SVProgressHUD dismiss];
        
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO];
        }
        
        [RMessage showNotificationInViewController:self.navigationController
                                             title:NSLocalizedString(@"Warning !", nil)
                                          subtitle:NSLocalizedString(@"Please fill all mandatory fields.", nil)
                                         iconImage:nil
                                              type:RMessageTypeWarning
                                    customTypeName:nil
                                          duration:RMessageDurationAutomatic
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionNavBarOverlay
                              canBeDismissedByUser:YES];
        
        
    }else{
        
        [self performSelector:@selector(save) withObject:self afterDelay:2.0];
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
        
    }
    else{
        
        from_id=[NSNumber numberWithInteger:1+[_fromArray indexOfObject:_fromTextField.text]];
        department_id = [NSNumber numberWithInteger:1+[_departmentArray indexOfObject:_departmentTextField.text]];
        impact_id = [NSNumber numberWithInteger:1+[_impactArray indexOfObject:_impactTextField.text]];
        status_id = [NSNumber numberWithInteger:1+[_statusArray indexOfObject:_statusTextField.text]];
        location_id = [NSNumber numberWithInteger:1+[_locationArray indexOfObject:_locationTextField.text]];
        priority_id = [NSNumber numberWithInteger:1+[_priorityArray indexOfObject:_priorityTextField.text]];
        assigned_id = [NSNumber numberWithInteger:1+[_assignedArray indexOfObject:_assigneeTextField.text]];
      //  asset_id = [NSNumber numberWithInteger:1+[_assetArray indexOfObject:_assetsTextField.text]];
        
        
         [SVProgressHUD showWithStatus:@"Saving data"];
        
         NSString *staffID= [NSString stringWithFormat:@"%@",assigned_id];
        
        if (([_assigneeTextField.text isEqualToString:@"Not Available"])||([staffID isEqualToString:@""] && [_assigneeTextField.text isEqualToString:@"Select Assignee"]) || ([staffID isEqualToString:@""] || [_assigneeTextField.text isEqualToString:@"Select Assignee"]))
        {
            staffID=@"0";
        }
        else
            if (staffID == (id)[NSNull null] || staffID.length == 0 || staffID == nil || [staffID isEqualToString:@"(null)"])
            {
                staffID=AssignID;
                
                NSLog(@"Assssissisinne id : %@",AssignID);
              
                NSLog(@"IDDDDDDDD id : %@",staffID);
            }
        
        NSString *locatioinID= [NSString stringWithFormat:@"%@",location_id];
        
        if ([_locationTextField.text isEqualToString:@"Not Available"]){
            
            locatioinID=@"0";
        }
        
        // checking assets are present or not, if present then pass assets to edit problem API
        
        NSMutableArray * assetArray1 = [[NSMutableArray alloc]init];
        
        if([self->globalVariables.asstArray count] !=0){
            
            for(NSDictionary *dict in globalVariables.asstArray){
                
                NSString *id1 = [dict objectForKey:@"id"];
                NSLog(@"asset[]: %@",id1);
    
                [assetArray1 addObject:[NSString stringWithFormat:@"asset[]=%@",id1]];
            }
            
            NSLog(@"Array is : %@",assetArray1);
            
            assetIds = [assetArray1 componentsJoinedByString:@",&"];
            NSLog(@"Final Array is : %@",assetIds);
            
        }else{
            
            
        }
        
        
//
//        http://productdemourl.com/servicedesk38t/public/api/v1/servicedesk/problem/2?//token&subject&description&from&department&status_type_id&impact_id&priority_id&location_type_id&assigned_id
        
        NSString *url=[NSString stringWithFormat:@"%@servicedesk/problem/%@?token=%@&subject=%@&description=%@&from=%@&department=%@&status_type_id=%@&impact_id=%@&priority_id=%@&location_type_id=%@&assigned_id=%@&%@",[userDefaults objectForKey:@"companyURL"],globalVariables.problemId,[userDefaults objectForKey:@"token"],_subjectTextView.text,_descriptionTextView.text,_fromTextField.text,department_id,status_id,impact_id,priority_id,locatioinID,staffID,assetIds];
        
        NSLog(@"URL is : %@",url);
        
        //NSString * newUrl = [url stringByAppendingString:@"%@",assetIds];
        
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            
            [webservices callPATCHAPIWithAPIName:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                
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
                    
                    
                    NSLog(@"JSON-EditProblem-%@",json);
                    

                    NSDictionary * resultDict = [json objectForKey:@"data"];
                   
                    
                    if ( [resultDict count] == 0 ) {
                       //somewent wrong
                        [SVProgressHUD dismiss];
                        
                        [self->utils showAlertWithMessage:NSLocalizedString(@"Something Went Wrong.", nil) sendViewController:self];
                    }
                    else {
                        
                        NSString * msg = [resultDict objectForKey:@"success"];
                        if([msg isEqualToString:@"Problem Updated Successfully."]){
                            
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
                            
                            
                        ProblemList *problemVC=[self.storyboard instantiateViewControllerWithIdentifier:@"problemId"];
                            [self.navigationController pushViewController:problemVC animated:YES];
                            
                        }else{
                            
                            [self->utils showAlertWithMessage:NSLocalizedString(@"Something Went Wrong.", nil) sendViewController:self];
                            
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

@end
