//
//  EditChangeDetails.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/12/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "EditChangeDetails.h"
#import "SVProgressHUD.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "Reachability.h"
#import "GlobalVariables.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "Utils.h"
#import "ActionSheetStringPicker.h"
#import "ChangeList.h"
#import "ProblemDetailView.h"
#import "ProblemList.h"
#import "SampleNavigation.h"

@interface EditChangeDetails ()<RMessageProtocol,UITextFieldDelegate,UITextViewDelegate>
{
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    NSNumber *requester_id;
    NSNumber *impact_id;
    NSNumber *status_id;
    NSNumber *location_id;
    NSNumber *priority_id;
    NSNumber *changeType_id;
    NSNumber *asset_id;
    
    NSMutableArray * requester_idArray;
    NSMutableArray * impact_idArray;
    NSMutableArray * status_idArray;
    NSMutableArray * location_idArray;
    NSMutableArray * priority_idArray;
    NSMutableArray * changeType_idArray;
    NSMutableArray * asset_idArray;
    
    NSString * descriptionData;
    NSString * subjectData;
    
}

- (void)requesterWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)statusWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)changeTypeWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)impactWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)locationWasSelected:(NSNumber *)selectedIndex element:(id)element;
//- (void)assetWasSelected:(NSNumber *)selectedIndex element:(id)element;

- (void)actionPickerCancelled:(id)sender;

@end

@implementation EditChangeDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    utils=[[Utils alloc]init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalVariables=[GlobalVariables sharedInstance];
    
    _requesterArray=[[NSMutableArray alloc]init];
    _impactTypeArray=[[NSMutableArray alloc]init];
    _statusArray=[[NSMutableArray alloc]init];
    _locationArray=[[NSMutableArray alloc]init];
    _priorityArray=[[NSMutableArray alloc]init];
    _changeTypeArray=[[NSMutableArray alloc]init];
    _assetArray=[[NSMutableArray alloc]init];
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD showWithStatus:@"Please wait"];
    [self reload];
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getMetaDataForChange];
}

- (IBAction)requesterTextFieldTouched:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_requesterArray||!_requesterArray.count) {
            _requesterTextField.text=NSLocalizedString(@"Not Available",nil);
            requester_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Requester" rows:_requesterArray initialSelection:0 target:self successAction:@selector(requesterWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
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
        NSLog( @" I am in requesterTextFieldClicked method in Edit Change VC" );
        
    }
}

- (IBAction)impactTypeTextFieldClicked:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_impactTypeArray||!_impactTypeArray.count) {
            _impactTextField.text=NSLocalizedString(@"Not Available",nil);
            impact_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Impact Type" rows:_impactTypeArray initialSelection:0 target:self successAction:@selector(impactWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
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
        NSLog( @" I am in impactTextFieldClicked method in Edit Change VC" );
        
    }
}

- (IBAction)statusTextFieldTouched:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_statusArray||!_statusArray.count) {
            _statusTextField.text=NSLocalizedString(@"Not Available",nil);
            status_id=0;
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
        NSLog( @" I am in statusTextFieldClicked method in Edit Change VC" );
        
    }
}

- (IBAction)priorityTextFieldTouched:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_priorityArray||!_priorityArray.count) {
            _priorityTextField.text=NSLocalizedString(@"Not Available",nil);
            priority_id=0;
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
        NSLog( @" I am in priorityTextFieldClicked method in Edit Change VC" );
        
    }
}

- (IBAction)changeTypeTextFieldTouched:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_changeTypeArray||!_changeTypeArray.count) {
            _changeTypeTextField.text=NSLocalizedString(@"Not Available",nil);
            changeType_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Change Type" rows:_changeTypeArray initialSelection:0 target:self successAction:@selector(changeTypeWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
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
        NSLog( @" I am in changeTypeTextFieldClicked method in Edit Change VC" );
        
    }
}

- (IBAction)locationTextFieldTouched:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_locationArray||!_locationArray.count) {
            _locationTextField.text=NSLocalizedString(@"Not Available",nil);
            location_id=0;
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
        NSLog( @" I am in locationTextFieldClicked method in Edit Change VC" );
        
    }
}


- (void)actionPickerCancelled:(id)sender {
    
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
    
}

- (void)requesterWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    requester_id=(requester_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.requesterTextField.text = (_requesterArray)[(NSUInteger) [selectedIndex intValue]];
    
    NSLog(@"Id is: %@",requester_id); // it is getting email e.g  Id is: alokjena@gmail.com
    NSLog(@"Requester is: %@",_requesterTextField.text);
}
- (void)statusWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    status_id=(status_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.statusTextField.text = (_statusArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",status_id);
    NSLog(@"Status is: %@",_statusTextField.text);
    
}
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    priority_id=(priority_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.priorityTextField.text = (_priorityArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",priority_id);
    NSLog(@"Priority is: %@",_priorityTextField.text);
    
}
- (void)changeTypeWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    changeType_id=(changeType_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.changeTypeTextField.text = (_changeTypeArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",changeType_id);
    NSLog(@"Change is: %@",_priorityTextField.text);
}
- (void)impactWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    impact_id=(impact_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.impactTextField.text = (_impactTypeArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",impact_id);
    NSLog(@"From is: %@",_impactTextField.text);
}
- (void)locationWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    location_id=(location_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.locationTextField.text = (_locationArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",location_id);
    NSLog(@"Location is: %@",_locationTextField.text);
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
                        
                        if([msg isEqualToString:@"Error-404"] || [msg isEqualToString:@"Error-405"] ||[msg isEqualToString:@"405"])
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
                    else self->_requesterTextField.text = @"Not Found";
                    
                    
                    
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
                        
                        self->_changeTypeTextField.text = changeName;
                    }
                    else self->_changeTypeTextField.text = @"Not Found";
                    
                    
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


-(void)getMetaDataForChange{
    
    
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
        
        NSString *url=[NSString stringWithFormat:@"%@servicedesk/dependency?type=change&token=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"token"]];
        
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
                    
                    [self getMetaDataForChange];
                    
                    NSLog(@"Thread-change-dependency");
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
                    NSArray *requesterArray1 = [json objectForKey:@"requester"];
                    NSArray *impactArray1 = [json objectForKey:@"sd_impact_types"];
                    NSArray *statusArray1 = [json objectForKey:@"statuses"];
                    NSArray *locationArray1 = [json objectForKey:@"sd_locations"];
                    NSArray *priorityArray1 = [json objectForKey:@"sd_changes_priorities"];
                    NSArray *changeTypeArray1 = [json objectForKey:@"sd_changes_types"];
                    NSArray *assetsArray1 = [json objectForKey:@"assets"];
                    
                    NSMutableArray *requesterMU=[[NSMutableArray alloc]init];
                    NSMutableArray *impactMU=[[NSMutableArray alloc]init];
                    NSMutableArray *statusMU=[[NSMutableArray alloc]init];
                    NSMutableArray *locationMU=[[NSMutableArray alloc]init];
                    NSMutableArray *priorityMU=[[NSMutableArray alloc]init];
                    NSMutableArray *changeTypeMU=[[NSMutableArray alloc]init];
                    NSMutableArray *assetsMU=[[NSMutableArray alloc]init];
                    
                    
                    self->requester_id=[[NSNumber alloc]init];
                    self->impact_id=[[NSNumber alloc]init];
                    self->status_id=[[NSNumber alloc]init];
                    self->location_id=[[NSNumber alloc]init];
                    self->priority_id=[[NSNumber alloc]init];
                    self->changeType_id=[[NSNumber alloc]init];
                    self->asset_id=[[NSNumber alloc]init];
                    
                    self->requester_idArray =[[NSMutableArray alloc]init];
                    self->impact_idArray =[[NSMutableArray alloc]init];
                    self->status_idArray =[[NSMutableArray alloc]init];
                    self->location_idArray =[[NSMutableArray alloc]init];
                    self->priority_idArray =[[NSMutableArray alloc]init];
                    self->changeType_idArray =[[NSMutableArray alloc]init];
                    self->asset_idArray =[[NSMutableArray alloc]init];
                    
                    
                    
                    
                    
                    // Requester
                    for (NSMutableDictionary *dicc in requesterArray1) {
                        
                        if ([dicc objectForKey:@"email"]) {
                            
                            NSString * name= [NSString stringWithFormat:@"%@ %@",[dicc objectForKey:@"first_name"],[dicc objectForKey:@"last_name"]];
                            
                            
                            [Utils isEmpty:name];
                            
                            
                            if  (![Utils isEmpty:name] )
                            {
                                [requesterMU addObject:name];
                            }
                            else
                            {
                                NSString * userName= [NSString stringWithFormat:@"%@",[dicc objectForKey:@"user_name"]];
                                [requesterMU addObject:userName];
                            }
                            
                            [self->requester_idArray addObject:[dicc objectForKey:@"email"]];
                            
                        }
                        
                    }
                    
                    
                    // impact
                    for (NSDictionary *dicc in impactArray1) {
                        if ([dicc objectForKey:@"name"]) {
                            [impactMU addObject:[dicc objectForKey:@"name"]];
                            [self->impact_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    // status
                    for (NSDictionary *dicc in statusArray1) {
                        if ([dicc objectForKey:@"name"]) {
                            [statusMU addObject:[dicc objectForKey:@"name"]];
                            [self->status_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    //location
                    for (NSDictionary *dicc in locationArray1) {
                        if ([dicc objectForKey:@"title"]) {
                            [locationMU addObject:[dicc objectForKey:@"title"]];
                            [self->location_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    //priority
                    for (NSDictionary *dicc in priorityArray1) {
                        if ([dicc objectForKey:@"name"]) {
                            [priorityMU addObject:[dicc objectForKey:@"name"]];
                            [self->priority_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    //asset
                    for (NSDictionary *dicc in assetsArray1) {
                        if ([dicc objectForKey:@"name"]) {
                            [assetsMU addObject:[dicc objectForKey:@"name"]];
                            [self->asset_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    
                    //change type
                    for (NSDictionary *dicc in changeTypeArray1) {
                        if ([dicc objectForKey:@"name"]) {
                            [changeTypeMU addObject:[dicc objectForKey:@"name"]];
                            [self->changeType_idArray addObject:[dicc objectForKey:@"id"]];
                            
                        }
                    }
                    
                    self->_requesterArray=[requesterMU copy];
                    self->_impactTypeArray=[impactMU copy];
                    self->_statusArray=[statusMU copy];
                    self->_locationArray=[locationMU copy];
                    self->_priorityArray=[priorityMU copy];
                    self->_changeTypeArray=[changeTypeMU copy];
                    self->_assetArray=[assetsMU copy];
                    
                }
                NSLog(@"Thread-all-change-dependency-closed");
                [SVProgressHUD dismiss];
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
            NSLog( @" I am in get metadata for change in Edit Change VC" );
            
        }
    }
    
}



- (IBAction)updateButtonClicked:(id)sender{
    
    [SVProgressHUD showWithStatus:@"Saving Details"];
    
    if(self.subjectTextView.text.length==0 || self.descriptionTextView.text.length==0 || self.requesterTextField.text.length==0 || self.impactTextField.text.length==0 || self.statusTextField.text.length==0 || self.priorityTextField.text.length==0 || self.changeTypeTextField.text.length==0 )
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
        
        
    }
    else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self->subjectData = [NSString stringWithFormat:@"%@",self->_subjectTextView.text];
            self->descriptionData = [NSString stringWithFormat:@"%@",self->_descriptionTextView.text];
            
            [self performSelector:@selector(EditChangeAPICall) withObject:self afterDelay:2.0];
            
        });
        
    }
    
}

-(void)EditChangeAPICall{
    
    
    
}

@end
