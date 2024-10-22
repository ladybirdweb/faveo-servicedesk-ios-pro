//
//  ClientListViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ClientListViewController.h"
#import "Utils.h"
#import "GlobalVariables.h"
#import "Reachability.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "AWNavigationMenuItem.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "ClientListTableViewCell.h"
#import "LoadingTableViewCell.h"
#import "UIImageView+Letters.h"
#import "ClientDetailsViewController.h"
#import "UIColor+HexColors.h"
#import "ClientFilter.h"
#import "SearchViewController.h"

@interface ClientListViewController ()<RMessageProtocol,AWNavigationMenuItemDataSource, AWNavigationMenuItemDelegate>{

    Utils *utils;
    GlobalVariables *globalVariables;
    NSUserDefaults *userDefaults;
    
    UIRefreshControl *refresh;
    
    NSString *url;
    NSString *tempString;
    NSMutableAttributedString *attributedMenu;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalTickets;
@property (nonatomic, strong) NSString *nextPageUrl;

@property (nonatomic, strong) AWNavigationMenuItem *menuItem;
@property (nonatomic, strong) NSArray<NSString *> *titles;


@end

@implementation ClientListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:NSLocalizedString(@"Users List",nil)];
    
    
    utils=[[Utils alloc]init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalVariables=[GlobalVariables sharedInstance];
    
    [self addUIRefresh];
    
    self.titles = @[NSLocalizedString(@"All users", nil),NSLocalizedString(@"Agent users", nil) , NSLocalizedString(@"Active users", nil),NSLocalizedString(@"Banned users", nil),NSLocalizedString(@"Inactive users", nil),NSLocalizedString(@"Deactivated users",nil)];
    
    self.menuItem = [[AWNavigationMenuItem alloc] init];
    self.menuItem.dataSource = self;
    self.menuItem.delegate = self;
    
    UIButton *search =  [UIButton buttonWithType:UIButtonTypeCustom];
    [search setImage:[UIImage imageNamed:@"search1"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [search setFrame:CGRectMake(46, 0, 32, 32)];
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:search];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    
    // to show side menu-menu 
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading users",nil)];
    
    [self reload];
    
}

- (IBAction)searchButtonClicked {
    
    SearchViewController * search=[self.storyboard instantiateViewControllerWithIdentifier:@"searchViewId"];
    [self.navigationController pushViewController:search animated:YES];
}


-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    { [refresh endRefreshing];
        //connection unavailable
        
        
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
        
        
      //  [[AppDelegate sharedAppdelegate] hideProgressView];
        [SVProgressHUD dismiss];
        
        
        
    }else{
        
        if([globalVariables.userFilterId isEqualToString:@"AGENTUSERS"])
        {
            tempString=@"agent";
            url= [NSString stringWithFormat:@"%@api/v2/helpdesk/user/filter?api_key=%@&token=%@&role=%@",[userDefaults objectForKey:@"baseURL"],API_KEY,[userDefaults objectForKey:@"token"],tempString];
            
        }else  if([globalVariables.userFilterId isEqualToString:@"ACTIVEUSERS"])
        {
            // api_key=&token=&active=1
            tempString=[NSString stringWithFormat:@"%i",1];
            url= [NSString stringWithFormat:@"%@api/v2/helpdesk/user/filter?api_key=%@&token=%@&active=%@",[userDefaults objectForKey:@"baseURL"],API_KEY,[userDefaults objectForKey:@"token"],tempString];
            
        }
//        else  if([globalVariables.userFilterId isEqualToString:@"CLIENTUSERS"])
//        {
//            tempString=@"user";
//            url= [NSString stringWithFormat:@"%@api/v2/helpdesk/user/filter?api_key=%@&token=%@&role=%@",[userDefaults objectForKey:@"baseURL"],API_KEY,[userDefaults objectForKey:@"token"],tempString];
//            
//        }
        else  if([globalVariables.userFilterId isEqualToString:@"BANNEDUSERS"])
        {
            tempString=[NSString stringWithFormat:@"%i",1];
            url= [NSString stringWithFormat:@"%@api/v2/helpdesk/user/filter?api_key=%@&token=%@&ban=%@",[userDefaults objectForKey:@"baseURL"],API_KEY,[userDefaults objectForKey:@"token"],tempString];
            
        }else  if([globalVariables.userFilterId isEqualToString:@"INACTIVEUSERS"])
        {
            tempString=[NSString stringWithFormat:@"%i",0];
            url= [NSString stringWithFormat:@"%@api/v2/helpdesk/user/filter?api_key=%@&token=%@&active=%@",[userDefaults objectForKey:@"baseURL"],API_KEY,[userDefaults objectForKey:@"token"],tempString];
        }else  if([globalVariables.userFilterId isEqualToString:@"DEACTIVEUSERS"])
        {
            //deleted users
            tempString=[NSString stringWithFormat:@"%i",1];
            url= [NSString stringWithFormat:@"%@api/v2/helpdesk/user/filter?api_key=%@&token=%@&deleted=%@",[userDefaults objectForKey:@"baseURL"],API_KEY,[userDefaults objectForKey:@"token"],tempString];
            
        }else if([globalVariables.userFilterId isEqualToString:@"ALLUSERS"])
        {
            
            url=[NSString stringWithFormat:@"%@helpdesk/customers-custom?api_key=%@&ip=%@&token=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"]];
            
        }else
        {
            
            url=[NSString stringWithFormat:@"%@helpdesk/customers-custom?api_key=%@&ip=%@&token=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"]];
            
            
        }
        
        //        [[AppDelegate sharedAppdelegate] showProgressView];
                  [SVProgressHUD showWithStatus:@"Loading users"];
        
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                
                if (error || [msg containsString:@"Error"]) {
                    [self->refresh endRefreshing];
                   // [[AppDelegate sharedAppdelegate] hideProgressView];
                      [SVProgressHUD dismiss];
                    
                    if (msg) {
                        
                        if([msg isEqualToString:@"Error-401"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access Denied.  Your credentials has been changed. Contact to Admin and try to login again."] sendViewController:self];
                        }
                        else
                            
                            if([msg isEqualToString:@"Error-402"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"API is disabled in web, please enable it from Admin panel."] sendViewController:self];
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
                            else{
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                            }
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                        //[[AppDelegate sharedAppdelegate] hideProgressView];
                          [SVProgressHUD dismiss];
                    }
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self reload];
                    NSLog(@"Thread--NO4-call-getClients");
                    return;
                }
                if ([msg isEqualToString:@"tokenNotRefreshed"]) {
                    
                    [self->utils showAlertWithMessage:@"Your HELPDESK URL or your Login credentials were changed, contact to Admin and please log back in." sendViewController:self];
                   // [[AppDelegate sharedAppdelegate] hideProgressView];
                     [SVProgressHUD dismiss];
                    
                    return;
                }
                
                if (json) {
                    //NSError *error;
                    self->_mutableArray=[[NSMutableArray alloc]initWithCapacity:11];
                    NSLog(@"Thread-NO4--getClientsAPI--%@",json);
                    
                    self->_mutableArray = [json objectForKey:@"data"];
                    self->_nextPageUrl =[json objectForKey:@"next_page_url"];
                    self->_currentPage=[[json objectForKey:@"current_page"] integerValue];
                    self->_totalTickets=[[json objectForKey:@"total"] integerValue];
                    self->_totalPages=[[json objectForKey:@"last_page"] integerValue];
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            [self->refresh endRefreshing];
                           // [[AppDelegate sharedAppdelegate] hideProgressView];
                            [SVProgressHUD dismiss];
                            
                            
                        });
                    });
                    
                }
                NSLog(@"Thread-NO5-getClients-closed");
                
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
            NSLog( @" I am in reload method in ClientList ViewController" );
            
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == [_mutableArray count] - 1 ) {
        NSLog(@"nextURL  %@",_nextPageUrl);
        if (( ![_nextPageUrl isEqual:[NSNull null]] ) && ( [_nextPageUrl length] != 0 )) {
            [self loadMore];
        }
        else{
            
            [RMessage showNotificationInViewController:self
                                                 title:nil
                                              subtitle:NSLocalizedString(@"All Caught Up.", nil)
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


-(void)loadMore{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
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
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices getNextPageURL:_nextPageUrl callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                if (error || [msg containsString:@"Error"]) {
                    
                    if (msg) {
                        
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-LoadMoreUsers-error == %@",error.localizedDescription);
                    }
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self loadMore];
                    return;
                }
                
                if (json) {
                    NSLog(@"Thread-NO4--getInboxAPI--%@",json);
                    
                    self->_nextPageUrl =[json objectForKey:@"next_page_url"];
                    self->_currentPage=[[json objectForKey:@"current_page"] integerValue];
                    self->_totalTickets=[[json objectForKey:@"total"] integerValue];
                    self->_totalPages=[[json objectForKey:@"last_page"] integerValue];
                    
                    self->_mutableArray= [self->_mutableArray mutableCopy];
                    
                    [self->_mutableArray addObjectsFromArray:[json objectForKey:@"data"]];
                    
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                            
                        });
                    });
                    
                }
                NSLog(@"Thread-LoadMoreClients-closed");
                
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
            NSLog( @" I am in loadMore method in ClientList ViewController" );
            
        }
        
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentPage == self.totalPages
        || self.totalTickets == _mutableArray.count) {
        return _mutableArray.count;
    }
    return _mutableArray.count + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if ([_mutableArray count]==0)
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        noDataLabel.text             =  NSLocalizedString(@"",nil);
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tableView.backgroundView = noDataLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tableView.backgroundView = nil;
    }
    
    return numOfSections;
}

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
        
        
        ClientListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ClientListCellID"];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClientListTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];
        
        @try{
            
            NSString *email=[finaldic objectForKey:@"email"];
            
            NSString *mobile=[finaldic objectForKey:@"mobile"];
            NSString *phone=[finaldic objectForKey:@"phone_number"];
            NSString *telephone=[finaldic objectForKey:@"telephone"];
            
            [Utils isEmpty:email];
            [Utils isEmpty:mobile];
            [Utils isEmpty:phone];
            [Utils isEmpty:telephone];
            
            if(![Utils isEmpty:email])
            {
                cell.emailIdLabel.text=email;
            }
            else{
                cell.emailIdLabel.text=NSLocalizedString(@"Not Available",nil);
            }
            
            NSString *code= [NSString stringWithFormat:@"%@",[finaldic objectForKey:@"mobile_code"]];
            [Utils isEmpty:code];
            
            NSString *codeTemp;
            
            if( ![Utils isEmpty:code])
            {
                if([code isEqualToString:@"0"])
                {
                    codeTemp=@"";
                    
                }
                else
                {
                    codeTemp =[NSString stringWithFormat:@"+%@",[finaldic objectForKey:@"mobile_code"]];
                }
            }
            else
            {
                codeTemp =@"";
            }
            //cell.codeLabel.text= [NSString stringWithFormat:@"%@",[finaldic objectForKey:@"mobile_code"]];
            
            
            if(! [Utils isEmpty:phone])
            {
                cell.phoneNumberLabel.text= [NSString stringWithFormat:@"%@ %@",codeTemp,phone];
            }
            else if(![Utils isEmpty:telephone])
            {
                cell.phoneNumberLabel.text= [NSString stringWithFormat:@"%@ %@",codeTemp,telephone];
            }
            else if( ![Utils isEmpty:mobile])
            {
                cell.phoneNumberLabel.text=[NSString stringWithFormat:@"%@ %@",codeTemp,mobile];
            }
            
            else
            {
                cell.phoneNumberLabel.text=NSLocalizedString(@"Not Available",nil);
            }
            
            
            
            NSString *clientFirstName=[finaldic objectForKey:@"first_name"];
            NSString *clientLastName=[finaldic objectForKey:@"last_name"];
            NSString *userName= [finaldic objectForKey:@"user_name"];
            
            [Utils isEmpty:clientFirstName];
            [Utils isEmpty:clientLastName];
            [Utils isEmpty:userName];
            
            if(![Utils isEmpty:clientFirstName] && ![Utils isEmpty:clientLastName])
            {
                cell.clientNameLabel.text=[NSString stringWithFormat:@"%@ %@",[finaldic objectForKey:@"first_name"],[finaldic objectForKey:@"last_name"]];
            }
            
            else if (![Utils isEmpty:clientFirstName] && [Utils isEmpty:clientLastName])
            {
                cell.clientNameLabel.text=[NSString stringWithFormat:@"%@",[finaldic objectForKey:@"first_name"]];
            }
            else if(![Utils isEmpty:userName])
            {
                cell.clientNameLabel.text= [finaldic objectForKey:@"user_name"];
            }
            else
            {
                cell.clientNameLabel.text=NSLocalizedString(@"Not Available",nil);
            }
            
            //Image view
            if(![Utils isEmpty:clientFirstName])
            {
                if([[finaldic objectForKey:@"profile_pic"] hasSuffix:@".jpg"] || [[finaldic objectForKey:@"profile_pic"] hasSuffix:@".jpeg"] || [[finaldic objectForKey:@"profile_pic"] hasSuffix:@".png"] )
                {
                    [cell setUserProfileimage:[finaldic objectForKey:@"profile_pic"]];
                }else
                {
                    [cell.profilePicView setImageWithString:clientFirstName color:nil ];
                }
                
            }
            else{
                [cell.profilePicView setImageWithString:email color:nil ];
            }
            // [cell setUserProfileimage:[finaldic objectForKey:@"profile_pic"]];
            
            //        if (  ![[finaldic objectForKey:@"profile_pic"] isEqual:[NSNull null]]   )
            //        {
            //            [cell setUserProfileimage:[finaldic objectForKey:@"profile_pic"]];
            //
            //        }
            //        else
            //        {
            //            [cell setUserProfileimage:@"default_pic.png"];
            //        }
            
        }@catch (NSException *exception)
        {
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            [utils showAlertWithMessage:exception.name sendViewController:self];
            //  return;
        }
        @finally
        {
            NSLog( @" I am in cellForRowArIndexPath method in ClientList ViewController" );
            
        }
        
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];
    
    globalVariables.userIDFromUserList=[finaldic objectForKey:@"id"];
    
    globalVariables.First_nameFromUserList=[finaldic objectForKey:@"first_name"];
    globalVariables.Last_nameFromUserList=[finaldic objectForKey:@"last_name"];
    
    globalVariables.userNameFromUserList= [finaldic objectForKey:@"user_name"];
    
    globalVariables.emailFromUserList= [finaldic objectForKey:@"email"];
    globalVariables.phoneNumberFromUserList= [NSString stringWithFormat:@"%@",[finaldic objectForKey:@"phone_number"]];
    globalVariables.mobileNumberFromUserList= [NSString stringWithFormat:@"%@",[finaldic objectForKey:@"mobile"]];
    
    globalVariables.userStateFromUserList= [finaldic objectForKey:@"active"];
    globalVariables.mobilecodeFromUserList= [NSString stringWithFormat:@"%@",[finaldic objectForKey:@"mobile_code"]]; //compnayUser1
    
    globalVariables.customerFromView=@"normalView";
    globalVariables.userImageFromUserList= [NSString stringWithFormat:@"%@",[finaldic objectForKey:@"profile_pic"]];
     globalVariables.ActiveDeactiveStateOfUser1= [NSString stringWithFormat:@"%@",[finaldic objectForKey:@"is_delete"]];
    
    globalVariables.userRoleFromUserList=[finaldic objectForKey:@"role"];
    
    ClientDetailsViewController *cd=[self.storyboard instantiateViewControllerWithIdentifier:@"clientDetailsViewId"];
    [self.navigationController pushViewController:cd animated:YES];
}

// This method used to show refresh behind the table view.
-(void)addUIRefresh{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *refreshing = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refreshing",nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle,NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    refresh=[[UIRefreshControl alloc] init];
    refresh.tintColor=[UIColor whiteColor];
    // refresh.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    refresh.backgroundColor =  [UIColor colorFromHexString:@"BDBDBD"];
    refresh.attributedTitle =refreshing;
    [refresh addTarget:self action:@selector(reloadd) forControlEvents:UIControlEventValueChanged];
    [_tableView insertSubview:refresh atIndex:0];
   
}


-(void)reloadd{
    [self reload];
    //    [refresh endRefreshing];
}



#pragma mark - AWNavigationMenuItemDataSource

- (NSUInteger)numberOfRowsInNavigationMenuItem:(AWNavigationMenuItem *)inMenuItem
{
    return self.titles.count;
}

- (NSAttributedString *)navigationMenuItem:(AWNavigationMenuItem *)inMenuItem attributedMenuTitleAtIndex:(NSUInteger)inIndex
{
    
    attributedMenu = [[NSMutableAttributedString alloc] initWithString:self.titles[inIndex] attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16.f]}];
    
    globalVariables.nameInCilent=[NSString stringWithFormat:@"%@",attributedMenu];
    
    return (inIndex % 1) == 0 ? attributedMenu : nil;
}

- (CGRect)maskViewFrameInNavigationMenuItem:(AWNavigationMenuItem *)inMenuItem
{
    return self.view.frame;
}

#pragma mark - AWNavigationMenuItemDelegate

- (void)navigationMenuItem:(AWNavigationMenuItem *)inMenuItem selectionDidChange:(NSUInteger)inIndex
{
    if(inIndex==0)
    {
        NSLog(@"All users");
        globalVariables.userFilterId=@"ALLUSERS";
        
        ClientListViewController *view1=[self.storyboard instantiateViewControllerWithIdentifier:@"ClientListID"];
        
        [self.navigationController pushViewController:view1 animated:YES];
        
    }
    if(inIndex==1)
    {
        NSLog(@"Agent Users");
        globalVariables.userFilterId=@"AGENTUSERS";
        
        ClientFilter *view1=[self.storyboard instantiateViewControllerWithIdentifier:@"clientFilterId"];
        
        [self.navigationController pushViewController:view1 animated:YES];
    
        
    }
    if(inIndex==2)
    {
        NSLog(@"Active users");
        globalVariables.userFilterId=@"ACTIVEUSERS";
        ClientFilter *view1=[self.storyboard instantiateViewControllerWithIdentifier:@"clientFilterId"];
        //
        [self.navigationController pushViewController:view1 animated:YES];
        
       
    }
    if(inIndex==3)
    {
        NSLog(@"Client users");
        globalVariables.userFilterId=@"CLIENTUSERS";
        
        ClientFilter *view1=[self.storyboard instantiateViewControllerWithIdentifier:@"clientFilterId"];
        //
        [self.navigationController pushViewController:view1 animated:YES];
        

    }
    if(inIndex==4)
    {
        NSLog(@"Banned users");
        globalVariables.userFilterId=@"BANNEDUSERS";
        
        ClientFilter *view1=[self.storyboard instantiateViewControllerWithIdentifier:@"clientFilterId"];
        
        [self.navigationController pushViewController:view1 animated:YES];
    
        
    }
    if(inIndex==5)
    {
        NSLog(@"Inactive users");
        globalVariables.userFilterId=@"INACTIVEUSERS";
        
        ClientFilter *view1=[self.storyboard instantiateViewControllerWithIdentifier:@"clientFilterId"];
      
        [self.navigationController pushViewController:view1 animated:YES];
        
    }
    if(inIndex==6)
    {
        NSLog(@"Deactivated users");
        globalVariables.userFilterId=@"DEACTIVEUSERS";
        
        ClientFilter *view1=[self.storyboard instantiateViewControllerWithIdentifier:@"clientFilterId"];
        
        [self.navigationController pushViewController:view1 animated:YES];
        
       
    }
    
}

@end
