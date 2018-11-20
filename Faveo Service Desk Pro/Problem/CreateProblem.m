//
//  CreateProblem.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "CreateProblem.h"
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
#import "TicketDetailViewController.h"


@interface CreateProblem ()<RMessageProtocol,UITextFieldDelegate,UITextViewDelegate>
{
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
    
}

- (void)fromWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)departmentWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)impactWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)statusWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)locationWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)assigneeWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)assetWasSelected:(NSNumber *)selectedIndex element:(id)element;

- (void)actionPickerCancelled:(id)sender;


@end

@implementation CreateProblem

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Create Problem",nil)];
    
    utils=[[Utils alloc]init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalVariables=[GlobalVariables sharedInstance];
   
    
    //side menu initialization
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    
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
    
    
  //  [self getMetaDataForProblem];
    
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
                    
                    if( [msg containsString:@"Error-401"])
                        
                    {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Your Credential Has been changed"] sendViewController:self];
                        // [[AppDelegate sharedAppdelegate] hideProgressView];
                        
                    }
                    else
                        if( [msg containsString:@"Error-429"])
                            
                        {
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"your request counts exceed our limit"] sendViewController:self];
                            
                            
                        }
                    
                        else if( [msg isEqualToString:@"Error-403"] && [self->globalVariables.roleFromAuthenticateAPI isEqualToString:@"user"])
                            
                        {
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access Denied.  Your credentials/Role has been changed. Contact to Admin and try to login again."] sendViewController:self];
                            
                            
                        }
                    
                        else if( [msg containsString:@"Error-403"])
                            
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
        NSLog( @" I am in HelptopicCLicked method in CreateProblem ViewController" );
        
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
        NSLog( @" I am in HelptopicCLicked method in CreateProblem ViewController" );
        
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
        NSLog( @" I am in HelptopicCLicked method in CreateProblem ViewController" );
        
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
        NSLog( @" I am in HelptopicCLicked method in CreateProblem ViewController" );
        
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
        NSLog( @" I am in HelptopicCLicked method in CreateProblem ViewController" );
        
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
        NSLog( @" I am in HelptopicCLicked method in CreateProblem ViewController" );
        
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
        NSLog( @" I am in HelptopicCLicked method in CreateProblem ViewController" );
        
    }
    
    
}

- (IBAction)assetsTextFieldClicked:(id)sender {
    
   // NSLog(@"Assets are: %@",_assetArray);
    
    @try{
        [self.view endEditing:YES];
        if (!_assetArray || !_assetArray.count) {
            _assetTextField.text=NSLocalizedString(@"Not Available",nil);
            from_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Assets" rows:_assetArray initialSelection:0 target:self successAction:@selector(assetWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
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
        NSLog( @" I am in Add Assets method in CreateProblem ViewController" );
        
    }
    
}



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

- (void)assetWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    asset_id=(asset_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.assetTextField.text = (_assetArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",asset_id);
    NSLog(@"From is: %@",_assetTextField.text);
}


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
        
         [self performSelector:@selector(postTicketProblem) withObject:self afterDelay:3.0];
    }
    
}


-(void)postTicketProblem{
    
    NSString *urlString;
    
    if([globalVariables.createProblemConditionforVC isEqualToString:@"newWithTicket"])
    {
       
       urlString=[NSString stringWithFormat:@"%@servicedesk/attach/problem/ticket?token=%@&ticketid=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"token"],globalVariables.ticketIdForTicketDetail];
        
    }
    else{
        
       urlString=[NSString stringWithFormat:@"%@servicedesk/problem/create?token=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"token"]];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    // subject parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"subject\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[_subjectTextView.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // description parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[_descriptionTextView.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
     NSString * fromId=[NSString stringWithFormat:@"%@",from_id];
    // from parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"from\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[fromId
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString * statusId=[NSString stringWithFormat:@"%@",status_id];
    // status parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"status_type_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[statusId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString * prioId=[NSString stringWithFormat:@"%@",priority_id];
    // prority parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"priority_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[prioId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString * impactId=[NSString stringWithFormat:@"%@",impact_id];
    // impact parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"impact_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[impactId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString * deptId=[NSString stringWithFormat:@"%@",department_id];
    // dept parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"department\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[deptId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString * locationId=[NSString stringWithFormat:@"%@",location_id];
    // location parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location_type_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[locationId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSString * assignId=[NSString stringWithFormat:@"%@",assigned_id];
    // assigned parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"assigned_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[assignId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    

    NSString * assetId=[NSString stringWithFormat:@"%@",asset_id];
    // asset parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"asset\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[assetId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    NSLog(@"Request is : %@",request);
    
    //
    //return and test
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"ReturnString : %@", returnString);
    
    NSError *error=nil;
    NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
    if (error) {
        return;
    }
    
    NSLog(@"Dictionary is : %@",jsonData);
    
  
      if([globalVariables.createProblemConditionforVC isEqualToString:@"newAlone"])
        {
            NSDictionary *data = [jsonData objectForKey:@"data"];
            NSString *msg = [data objectForKey:@"success"];
            
            if([msg isEqualToString:@"Problem Created Successfully."]){
                
                [SVProgressHUD dismiss];
                
                if (self.navigationController.navigationBarHidden) {
                    [self.navigationController setNavigationBarHidden:NO];
                }
                
                [RMessage showNotificationInViewController:self.navigationController
                                                     title:NSLocalizedString(@"success", nil)
                                                  subtitle:NSLocalizedString(@"Problem created successfully.", nil)
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
                
            }
            
        }
        else if([globalVariables.createProblemConditionforVC isEqualToString:@"newWithTicket"]){
            
            NSString * dataMessage = [jsonData objectForKey:@"data"];
            
            if([dataMessage isEqualToString:@"Created new problem and attached to this ticket"]){
                
                [SVProgressHUD dismiss];
                
                if (self.navigationController.navigationBarHidden) {
                    [self.navigationController setNavigationBarHidden:NO];
                }
                
                [RMessage showNotificationInViewController:self.navigationController
                                                     title:NSLocalizedString(@"success", nil)
                                                  subtitle:NSLocalizedString(@"Problem attached successfully.", nil)
                                                 iconImage:nil
                                                      type:RMessageTypeSuccess
                                            customTypeName:nil
                                                  duration:RMessageDurationAutomatic
                                                  callback:nil
                                               buttonTitle:nil
                                            buttonCallback:nil
                                                atPosition:RMessagePositionNavBarOverlay
                                      canBeDismissedByUser:YES];
                
                
                globalVariables.ticketId= [NSNumber numberWithInt:[globalVariables.ticketIdForTicketDetail intValue]];
                
                 TicketDetailViewController *td=[self.storyboard instantiateViewControllerWithIdentifier:@"ticketDetailViewId"];
                [self.navigationController pushViewController:td animated:YES];
                
            }
            
        
        else {
            NSString *str=[jsonData objectForKey:@"message"];
            
            if([str isEqualToString:@"Token expired"])
            {
                
                MyWebservices *web=[[MyWebservices alloc]init];
                [web refreshToken];
                [self postTicketProblem];
                
            }
            else{
                
                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Someting went wrong. Please try again later.."] sendViewController:self];
                [SVProgressHUD dismiss];
                
            }
            
        
        }
            
        }
    
}

// this method used to control writing data/texts in textfields and textviews.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if(textView == _subjectTextView || textView == _descriptionTextView)
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
        
        if([textView.text stringByReplacingCharactersInRange:range withString:text].length >800)
        {
            return NO;
        }
        
        NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.';;:?()*&%, "];
        
        
        if([text rangeOfCharacterFromSet:set].location == NSNotFound)
        {
            return NO;
        }
    }
    
    
    return YES;
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


@end
