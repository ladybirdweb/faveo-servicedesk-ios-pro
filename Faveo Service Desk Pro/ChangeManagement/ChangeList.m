//
//  ChangeList.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 18/01/19.
//  Copyright © 2019 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ChangeList.h"
#import "Utils.h"
#import "MyWebservices.h"
#import "GlobalVariables.h"
#import "SWRevealViewController.h"
#import "ChangesTableViewCell.h"
#import "SVProgressHUD.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "Reachability.h"
#import "LoadingTableViewCell.h"
#import "ProblemDetailView.h"
#import "UIColor+HexColors.h"
#import "UIColor+HexColors.h"
#import "CreateProblem.h"
#import "AppConstanst.h"
#import "ChangeDetailView.h"
#import "CreateChanges.h"

@interface ChangeList ()<RMessageProtocol>
{
    
    Utils *utils;
    UIRefreshControl *refresh;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
}


@property (nonatomic, strong) NSMutableArray *mutableArray;

@property (nonatomic, strong) NSArray *indexPaths;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalTickets;
@property (nonatomic, strong) NSString *nextPageUrl;
@property (nonatomic, strong) NSString *path1;

@property (nonatomic) int pageInt;

@end

@implementation ChangeList

//It called after the controller's view is loaded into memory.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:NSLocalizedString(@"All Changes",nil)];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    
    _mutableArray=[[NSMutableArray alloc]init];
    
    //side menu initialization
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    
    // adding button on navigation
    UIButton *addButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"add1"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addNewChange) forControlEvents:UIControlEventTouchUpInside];
    //    [moreButton setFrame:CGRectMake(46, 0, 32, 32)];
    [addButton setFrame:CGRectMake(46, 0, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:addButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"Loading Changes"];
    
    [self addUIRefresh];
    [self reload];
    
}

-(void)addNewChange{

    globalVariables.createChangeConditionforVC = @"newChangeAlone";
    
    //add lines of code
    CreateChanges *createChange=[self.storyboard instantiateViewControllerWithIdentifier:@"CreateChangesId"];
    
    [self.navigationController pushViewController:createChange animated:YES];
  
}

-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [refresh endRefreshing];
        
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
        
        
        NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/all/changes?token=%@&api_key=%@",[userDefaults objectForKey:@"baseURL"],[userDefaults objectForKey:@"token"],API_KEY];
        NSLog(@"URL is : %@",url);
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                
                if (error || [msg containsString:@"Error"]) {
                    [self->refresh endRefreshing];
                    
                    
                    if (msg) {
                        
                        [SVProgressHUD dismiss];
                        
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
                        NSLog(@"Thread-Changes-Refresh-error == %@",error.localizedDescription);
                        [SVProgressHUD dismiss];
                    }
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    
                    [self reload];
                    NSLog(@"Thread-call-getAllChanges");
                    return;
                }
                
                if ([msg isEqualToString:@"tokenNotRefreshed"]) {
                    
                    // [self showMessageForLogout:@"Your HELPDESK URL or Your Login credentials were changed, contact to Admin and please log back in." sendViewController:self];
                    
                    [SVProgressHUD dismiss];
                    
                    return;
                }
                
                
                if (json) {
                    
                  //  NSLog(@"JSON is : %@",json);
                    
                    self->_mutableArray=[json objectForKey:@"data"];
                    
                    self->_nextPageUrl =[json objectForKey:@"next_page_url"];
                    self->_path1=[json objectForKey:@"path"];
                    self->_currentPage=[[json objectForKey:@"current_page"] integerValue];
                    self->_totalTickets=[[json objectForKey:@"total"] integerValue];
                    self->_totalPages=[[json objectForKey:@"last_page"] integerValue];
                    
                
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self reloadTableView];
                            [self->refresh endRefreshing];
                            [SVProgressHUD dismiss];
                            
                        });
                    });
                    
                }
                NSLog(@"Thread-changes-closed");
                
            }];
        }@catch (NSException *exception)
        {
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            [utils showAlertWithMessage:exception.name sendViewController:self];
            //  [self reloadTableView];
            return;
        }
        @finally
        {
            NSLog( @" I am in reload method in changes list ViewController" );
            
            
        }
    }
    
    
}


// Handling the tableview even we reload the tablview, edit view will not vanish even we scroll
- (void)reloadTableView
{
    NSArray *indexPaths = [self.sampleTableview indexPathsForSelectedRows];
    
    [self.sampleTableview reloadData];
    for (NSIndexPath *path in indexPaths) {
        [self.sampleTableview selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}


//This method asks the data source to return the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if ([_mutableArray count] != 0)
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tableView.backgroundView = nil;
        
    }
    else{
        
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        noDataLabel.text             = NSLocalizedString(@"No Records..!!!",nil);
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tableView.backgroundView = noDataLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return numOfSections;
    
}

// This method returns the number of rows (table cells) in a specified section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (self.currentPage == self.totalPages
        || self.totalTickets == _mutableArray.count) {
        return _mutableArray.count;
    }
    
    return _mutableArray.count + 1;
    
}



// This method tells the delegate the table view is about to draw a cell for a particular row
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //  cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    if (indexPath.row == [_mutableArray count] - 1 ) {
        NSLog(@"nextURL111  %@",_nextPageUrl);
        
        if (( ![_nextPageUrl isEqual:[NSNull null]] ) && ( [_nextPageUrl length] != 0 )) {
            
            [self loadMore];
            
            
        }
        else{
            
            [RMessage showNotificationInViewController:self
                                                 title:nil
                                              subtitle:NSLocalizedString(@"All Caught Up", nil)
                                             iconImage:nil
                                                  type:RMessageTypeSuccess
                                        customTypeName:nil
                                              duration:RMessageDurationAutomatic
                                              callback:nil
                                           buttonTitle:nil
                                        buttonCallback:nil
                                            atPosition:RMessagePositionBottom
                                  canBeDismissedByUser:YES];
        }
    }
    
    
}


// This method asks the data source for a cell to insert in a particular location of the table view.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.row == [_mutableArray count]) {
        
        LoadingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LoadingCellID"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoadingTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:1];
        [activityIndicator startAnimating];
        return cell;
    }else{
        
        
        ChangesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ChangesTableViewCellId"];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChangesTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        
        //created_at priority
        
        NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];
        
        NSString *changeName= [finaldic objectForKey:@"subject"];
        NSString *requesterName= [finaldic objectForKey:@"requester"];
        NSString *id1= [finaldic objectForKey:@"id"];
        NSString *createdDate= [finaldic objectForKey:@"created_at"];
        // NSString *prio= [finaldic objectForKey:@"created_at"];
        
       if(![Utils isEmpty:changeName]){
            cell.changeNameLabel1.text = changeName;
        }
       else{
           cell.changeNameLabel1.text = @"Title Not Available";
       }
        
       if(![Utils isEmpty:requesterName]){
           cell.requesterLabel.text = [NSString stringWithFormat:@"Requester: %@",requesterName];
       }
       else{
            cell.requesterLabel.text = [NSString stringWithFormat:@"Requester: Not Available"];
       }
        
       
        cell.changeNumber.text = [NSString stringWithFormat:@"#CNG-%@",id1];
        cell.createdDateLabel.text = [utils getLocalDateTimeFromUTC:createdDate];
        
        if(([[finaldic objectForKey:@"priority"] isEqualToString:@"Low"])){
            
            if( globalVariables.priorityColorLowForProblemsList == nil || [globalVariables.priorityColorLowForProblemsList isEqualToString:@""] || [globalVariables.priorityColorLowForProblemsList isKindOfClass:[NSNull class]]){
                cell.indicationView.layer.backgroundColor=[[UIColor colorFromHexString:@"#00a65a"] CGColor];
            }else{
            cell.indicationView.layer.backgroundColor=[[UIColor colorFromHexString:globalVariables.priorityColorLowForProblemsList] CGColor];
            }
        }
        else if(([[finaldic objectForKey:@"priority"] isEqualToString:@"Normal"])){
           
            if(globalVariables.priorityColorNormalProblemsList == nil || [globalVariables.priorityColorNormalProblemsList isEqualToString:@""] || [globalVariables.priorityColorNormalProblemsList isKindOfClass:[NSNull class]]){
                cell.indicationView.layer.backgroundColor=[[UIColor colorFromHexString:@"#00a65a"] CGColor];
            }else{
                cell.indicationView.layer.backgroundColor=[[UIColor colorFromHexString:globalVariables.priorityColorNormalProblemsList] CGColor];
            }
        }
        else if(([[finaldic objectForKey:@"priority"] isEqualToString:@"High"])){
            
            if( globalVariables.priorityColorHighProblemsList == nil ||[globalVariables.priorityColorHighProblemsList isEqualToString:@""] || [globalVariables.priorityColorHighProblemsList isKindOfClass:[NSNull class]]){
                cell.indicationView.layer.backgroundColor=[[UIColor colorFromHexString:@"#00a65a"] CGColor];
            }else{
                cell.indicationView.layer.backgroundColor=[[UIColor colorFromHexString:globalVariables.priorityColorHighProblemsList] CGColor];
            }
            
        }
        else if(([[finaldic objectForKey:@"priority"] isEqualToString:@"Emergency"])){
            
            if(globalVariables.priorityColorEmergencyProblemsList == nil || [globalVariables.priorityColorEmergencyProblemsList isEqualToString:@""] || [globalVariables.priorityColorEmergencyProblemsList isKindOfClass:[NSNull class]]){
                cell.indicationView.layer.backgroundColor=[[UIColor colorFromHexString:@"#00a65a"] CGColor];
            }else{
                cell.indicationView.layer.backgroundColor=[[UIColor colorFromHexString:globalVariables.priorityColorEmergencyProblemsList] CGColor];
            }
        }
        return cell;
    }
    
}



// This method tells the delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];
    globalVariables.changeId=[finaldic objectForKey:@"id"];
    
    ChangeDetailView *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangeDetailViewId"];
    
    [self.navigationController pushViewController:detail animated:YES];
   
}


// This method calls an API for getting next page tickets, it will returns an JSON which contains 10 records with ticket details.
-(void)loadMore{
    
    
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
        
        @try{
            
            self.page = _page + 1;
            // NSLog(@"Page is : %ld",(long)_page);
            
            NSString *str=_nextPageUrl;
            NSString *Page = [str substringFromIndex:[str length] - 1];
            
            //     NSLog(@"String is : %@",szResult);
            NSLog(@"Page is : %@",Page);
            NSLog(@"Page is : %@",Page);
            
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices getNextPageURLProblemsList:_path1 pageNo:Page  callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                
                
                if (error || [msg containsString:@"Error"]) {
                    [SVProgressHUD dismiss];
                    
                    if (msg) {
                        
                        
                        
                        if([msg isEqualToString:@"Error-403"])
                        {
                            [self->utils showAlertWithMessage:NSLocalizedString(@"Access Denied - You don't have permission.", nil) sendViewController:self];
                        }
                        else if([msg isEqualToString:@"Error-403"] && [self->globalVariables.roleFromAuthenticateAPI isEqualToString:@"user"])
                        {
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access Denied.  Your credentials/Role has been changed. Contact to Admin and try to login again."] sendViewController:self];
                            
                        }else{
                            
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                        }
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-problem-list-Refresh-error == %@",error.localizedDescription);
                        [SVProgressHUD dismiss];
                    }
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self loadMore];
                    
                    return;
                }
                
                if (json) {
                    
                    // NSDictionary *data1Dict=[json objectForKey:@"data"];
                    
                    self->_nextPageUrl =[json objectForKey:@"next_page_url"];
                    self->_path1=[json objectForKey:@"path"];
                    self->_currentPage=[[json objectForKey:@"current_page"] integerValue];
                    self->_totalTickets=[[json objectForKey:@"total"] integerValue];
                    self->_totalPages=[[json objectForKey:@"last_page"] integerValue];
                    
                    self->_mutableArray= [self->_mutableArray mutableCopy];
                    
                    [self->_mutableArray addObjectsFromArray:[json objectForKey:@"data"]];
                    
                    
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self reloadTableView];
                            
                            [SVProgressHUD dismiss];
                            
                        });
                    });
                    
                }
                NSLog(@"Thread-problems-list-closed");
                
            }];
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
            NSLog( @" I am in loadMore method in Problem List ViewController" );
            
        }
    }
}



// This methodn used to show refresh behind the table view.
-(void)addUIRefresh{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *refreshing = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refreshing",nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle,NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    refresh=[[UIRefreshControl alloc] init];
    refresh.tintColor=[UIColor whiteColor];
    refresh.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    // refresh.backgroundColor = [UIColor colorFromHexString:@"BDBDBD"];
    // [UIColor hx_colorWithHexRGBAString:@"#BDBDBD"];
    refresh.attributedTitle =refreshing;
    [refresh addTarget:self action:@selector(reloadd) forControlEvents:UIControlEventValueChanged];
    [_sampleTableview insertSubview:refresh atIndex:0];
    
}

// This method used to reload view
-(void)reloadd{
    [self reload];
    //    [refresh endRefreshing];
}





@end
