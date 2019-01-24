//
//  CreateChanges.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 18/01/19.
//  Copyright © 2019 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "CreateChanges.h"
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


@interface CreateChanges ()<RMessageProtocol,UITextFieldDelegate,UITextViewDelegate>
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
- (void)assetWasSelected:(NSNumber *)selectedIndex element:(id)element;

- (void)actionPickerCancelled:(id)sender;

@end


@implementation CreateChanges

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Create Change",nil)];
    
    utils=[[Utils alloc]init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalVariables=[GlobalVariables sharedInstance];
    
    
    //side menu initialization
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    
    _requesterArray=[[NSMutableArray alloc]init];
    _impactTypeArray=[[NSMutableArray alloc]init];
    _statusArray=[[NSMutableArray alloc]init];
    _locationArray=[[NSMutableArray alloc]init];
    _priorityArray=[[NSMutableArray alloc]init];
    _changeTypeArray=[[NSMutableArray alloc]init];
    _assetArray=[[NSMutableArray alloc]init];
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [SVProgressHUD showWithStatus:@"Please Wait..."];
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
        NSLog( @" I am in requesterTextFieldClicked method in Create Change VC" );
        
    }
    
}

- (IBAction)impactTypeTextFieldTouched:(id)sender {
    
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
        NSLog( @" I am in impactTextFieldClicked method in Create Change VC" );
        
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
        NSLog( @" I am in statusTextFieldClicked method in Create Change VC" );
        
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
        NSLog( @" I am in priorityTextFieldClicked method in Create Change VC" );
        
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
        NSLog( @" I am in changeTypeTextFieldClicked method in Create Change VC" );
        
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
        NSLog( @" I am in locationTextFieldClicked method in Create Change VC" );
        
    }
    
}


- (IBAction)assetTextFieldTouched:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_assetArray||!_assetArray.count) {
            _assetTextField.text=NSLocalizedString(@"Not Available",nil);
            asset_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Asset" rows:_assetArray initialSelection:0 target:self successAction:@selector(assetWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
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
        NSLog( @" I am in assetTextFieldClicked method in Create Change VC" );
        
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
- (void)assetWasSelected:(NSNumber *)selectedIndex element:(id)element{
    
    asset_id=(asset_idArray)[(NSUInteger) [selectedIndex intValue]];
    self.assetTextField.text = (_assetArray)[(NSUInteger) [selectedIndex intValue]];
    NSLog(@"Id is: %@",asset_id);
    NSLog(@"Asset is: %@",_assetTextField.text);
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
            NSLog( @" I am in get metadata for change in Create Change VC" );
            
        }
    }
    
}


- (IBAction)saveButtonClicked:(id)sender{
    
    [SVProgressHUD showWithStatus:@"Please wait"];
    
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
            
            [self performSelector:@selector(createChangeAPICall) withObject:self afterDelay:2.0];
            
        });
        
    }
}

-(void)createChangeAPICall{ //api/v1/servicedesk/change/create
    
    
    NSString *urlString;
    
    if([globalVariables.createChangeConditionforVC isEqualToString:@"newWithProblem"])
    {
        
        globalVariables.showNavigationItem = @"show";
        urlString=[NSString stringWithFormat:@"%@servicedesk/problem/change/%@?token=%@",[userDefaults objectForKey:@"companyURL"],globalVariables.problemId,[userDefaults objectForKey:@"token"]];
        
    }
    else{
        
        urlString=[NSString stringWithFormat:@"%@servicedesk/change/create?token=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"token"]];
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
    [body appendData:[subjectData dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // description parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[descriptionData dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString * requesterId=[NSString stringWithFormat:@"%@",requester_id];
    // requester parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"requester\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[requesterId
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString * statusId=[NSString stringWithFormat:@"%@",status_id];
    // status parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"status_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
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
    
    
    NSString * changeTypetId2=[NSString stringWithFormat:@"%@",changeType_id];
    // change type parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"change_type_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[changeTypetId2 dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString * locationId=[NSString stringWithFormat:@"%@",location_id];
    // location parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[locationId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString * assetId=[NSString stringWithFormat:@"%@",asset_id];
    // asset parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"asset[]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[assetId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    NSLog(@"Request is : %@",request);
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] ];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"ReturnString : %@", returnString);
        
        error=nil;
        
        NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSLog(@"Create Change Response Dictionary is : %@",jsonData);
        
        
        if([jsonData objectForKey:@"data"]){
            
            NSObject *data = [jsonData objectForKey:@"data"];
            
            if([data isKindOfClass:[NSString class]]){
                
                NSString *dataString = [jsonData objectForKey:@"data"];
                
                if([dataString isEqualToString:@"Changes Created."]){
                    
                    
                    [SVProgressHUD dismiss];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (self.navigationController.navigationBarHidden) {
                            [self.navigationController setNavigationBarHidden:NO];
                        }
                        
                        [RMessage showNotificationInViewController:self.navigationController
                                                             title:NSLocalizedString(@"success", nil)
                                                          subtitle:NSLocalizedString(@"Change created successfully.", nil)
                                                         iconImage:nil
                                                              type:RMessageTypeSuccess
                                                    customTypeName:nil
                                                          duration:RMessageDurationAutomatic
                                                          callback:nil
                                                       buttonTitle:nil
                                                    buttonCallback:nil
                                                        atPosition:RMessagePositionNavBarOverlay
                                              canBeDismissedByUser:YES];
                        ChangeList *changeListVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangeListId"];
                        [self.navigationController pushViewController:changeListVC animated:YES];
                        
                    });
                    
                }else{
                    
                    //something went wrong
                }
                
            } //checking json data is kind of string type
            
            else if([data isKindOfClass:[NSDictionary class]]){
                
                NSDictionary *dataDict = [jsonData objectForKey:@"data"];
                NSString *successMsg = [dataDict objectForKey:@"success"];
                
                if([successMsg isEqualToString:@"Changes Created."]){
                    
                    
                    [SVProgressHUD dismiss];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (self.navigationController.navigationBarHidden) {
                            [self.navigationController setNavigationBarHidden:NO];
                        }
                        
                        [RMessage showNotificationInViewController:self.navigationController
                                                             title:NSLocalizedString(@"success", nil)
                                                          subtitle:NSLocalizedString(@"Created new Change and attached to this problem.", nil)
                                                         iconImage:nil
                                                              type:RMessageTypeSuccess
                                                    customTypeName:nil
                                                          duration:RMessageDurationAutomatic
                                                          callback:nil
                                                       buttonTitle:nil
                                                    buttonCallback:nil
                                                        atPosition:RMessagePositionNavBarOverlay
                                              canBeDismissedByUser:YES];
                        
                        
                        self->globalVariables.problemId= [NSNumber numberWithInt:[self->globalVariables.problemId intValue]];
                        
                        self->globalVariables.test121 = @"111";
                        ProblemDetailView *td=[self.storyboard instantiateViewControllerWithIdentifier:@"ProblemDetailViewId"];
                        
                        //   [self.navigationController pushViewController:td animated:YES];
                        
                        SampleNavigation *slide = [[SampleNavigation alloc] initWithRootViewController:td];
                        
                        ProblemList *problemList = (ProblemList*)[self.storyboard instantiateViewControllerWithIdentifier:@"problemId"];
                        
                        // Initialize SWRevealViewController and set it as |rootViewController|
                        SWRevealViewController * vc= [[SWRevealViewController alloc]initWithRearViewController:problemList frontViewController:slide];
                        
                        [self presentViewController:vc animated:YES completion:nil];
                        
                    });
                    
                }
                else{
                    
                    //something went wrong
                }
                
            } //checking json data is kind of dictionary type
            
        } //end of main if checking object for key data
        else if([jsonData objectForKey:@"message"]){
            
            NSString *str=[jsonData objectForKey:@"message"];
            
            if([str isEqualToString:@"Token expired"])
            {
                
                MyWebservices *web=[[MyWebservices alloc]init];
                [web refreshToken];
                [self createChangeAPICall];
                
            }
        } // end if([jsonData objectForKey:@"message"])
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Someting went wrong. Please try again later.."] sendViewController:self];
                [SVProgressHUD dismiss];
            });
            
        }
        
        
        // Error:
        if (error) {
            return;
        }
        
        
    }] resume];
}

//This method used to control writing data/texts in textfields and textviews.
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
        
        NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890._-='+%@!;;:?()*&%, "];
        
        
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
