//
//  ClientDetailsViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ClientDetailsViewController.h"
#import "HexColors.h"
#import "Utils.h"
#import "Reachability.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "OpenCloseTableViewCell.h"
#import "GlobalVariables.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RMessage.h"
#import "RMessageView.h"
#import "ClientEditDetailsView.h"
#import "UIImageView+Letters.h"
#import "SVProgressHUD.h"
#import "TicketDetailViewController.h"
#import "SampleNavigation.h"
#import "ExpandableTableViewController.h"
#import "ClientListViewController.h"
#import "SWRevealViewController.h"

@interface ClientDetailsViewController ()<RMessageProtocol>
{
    Utils *utils;
    NSUserDefaults *userDefaults;
    NSMutableArray *mutableArray;
    UIRefreshControl *refresh;
    GlobalVariables *globalVariables;
    NSDictionary *requesterTempDict;
    NSString *code2;
}

@property (nonatomic,strong) UILabel *noDataLabel;

@end

@implementation ClientDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    utils=[[Utils alloc]init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalVariables=[GlobalVariables sharedInstance];
    
  //  _clientId=[NSString stringWithFormat:@"%@",globalVariables.userIDFromUserList];
    
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderColor=[[UIColor hx_colorWithHexRGBAString:@"#0288D1"] CGColor];
    
    if ([globalVariables.fromAppDelegateToVC isEqualToString:@"cd"]) {
        
        globalVariables.fromAppDelegateToVC = @"";
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backBtnClick:)];
        self.navigationItem.leftBarButtonItem = rightBtn;
        
    }
    
    UIButton *edit =  [UIButton buttonWithType:UIButtonTypeCustom];
    [edit setImage:[UIImage imageNamed:@"pencileEdit"] forState:UIControlStateNormal];
    [edit addTarget:self action:@selector(EditClientProfileMethod) forControlEvents:UIControlEventTouchUpInside];
    
    [edit setFrame:CGRectMake(50, 6, 20, 20)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:edit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    _testingLAbel.backgroundColor=[UIColor lightGrayColor];
    _testingLAbel.layer.cornerRadius=8;
    _testingLAbel.layer.masksToBounds=true;
    _testingLAbel.userInteractionEnabled=YES;
    
    _rolLabel.backgroundColor=[UIColor lightGrayColor];
    _rolLabel.layer.cornerRadius=8;
    _rolLabel.layer.masksToBounds=true;
    _rolLabel.userInteractionEnabled=YES;

    
    [self addUIRefresh];
    
    
    @try{
        
        NSString *email1= [NSString stringWithFormat:@"%@",globalVariables.emailFromUserList];
        
        [Utils isEmpty:email1];
        
        if (![Utils isEmpty:email1])
        {
            
            _emailLabel.text= [NSString stringWithFormat:@"%@",email1];
        }
        else
        {
            _mobileLabel.text= @"Not Available";
        }
        
        NSString *fname= [NSString stringWithFormat:@"%@",globalVariables.First_nameFromUserList];
        NSString *lname= [NSString stringWithFormat:@"%@",globalVariables.Last_nameFromUserList];
        NSString *userName= [NSString stringWithFormat:@"%@",globalVariables.userNameFromUserList];
        
        [Utils isEmpty:fname];
        [Utils isEmpty:lname];
        [Utils isEmpty:userName];
        
        
        if (![Utils isEmpty:fname] || ! [Utils isEmpty:lname] )
        {
            
            if (![Utils isEmpty:fname] && ! [Utils isEmpty:lname] )
            {
                _clientNameLabel.text= [NSString stringWithFormat:@"%@ %@",fname,lname];
            }
            else  if (![Utils isEmpty:fname] || ! [Utils isEmpty:lname] )
            {
                _clientNameLabel.text= [NSString stringWithFormat:@"%@ %@",fname,lname];
            }
            
        }else if(![Utils isEmpty:userName])
            
        {
            _clientNameLabel.text= [NSString stringWithFormat:@"%@",userName];
        }
        else
        {
            _clientNameLabel.text= @"Not Available";
            
        }
        
        
        NSString *phone1= [NSString stringWithFormat:@"%@",globalVariables.phoneNumberFromUserList];
        NSString *mobile1= [NSString stringWithFormat:@"%@", globalVariables.mobileNumberFromUserList];
        NSString *code1= [NSString stringWithFormat:@"%@",globalVariables.mobilecodeFromUserList];
        
        [Utils isEmpty:phone1];
        [Utils isEmpty:mobile1];
        [Utils isEmpty:code1];
        
        if (![Utils isEmpty:phone1])
        {
            if(![Utils isEmpty:phone1] && ![Utils isEmpty:code1])
            {
                _phoneLabel.text= [NSString stringWithFormat:@"+%@ %@",code1,phone1];
            }
            else
            {
                
                _phoneLabel.text= [NSString stringWithFormat:@"%@",phone1];
            }
        }else
        {
            _phoneLabel.text= @"Not Available";
        }
        
        if (![Utils isEmpty:mobile1])
        {
            
            _mobileLabel.text= [NSString stringWithFormat:@"%@",mobile1];
        }
        else
        {
            _mobileLabel.text= @"Not Available";
        }
        
        //Image view
        
        if([globalVariables.userImageFromUserList hasSuffix:@".jpg"] || [globalVariables.userImageFromUserList hasSuffix:@".jpeg"] || [globalVariables.userImageFromUserList hasSuffix:@".png"] )
        {
            [self setUserProfileimage:globalVariables.userImageFromUserList];
        }else if(![Utils isEmpty:fname])
        {
            // [cell.profilePicView setImageWithString:fname color:nil ];
            
            [_profileImageView setImageWithString:fname color:nil];
        }
        else
        {
            [_profileImageView setImageWithString:userName color:nil];
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
        NSLog( @" I am in viedDidLoad method in Client Detail ViewController" );
        
    }
    
    
    @try{
        NSString *role=[NSString stringWithFormat:@"%@",globalVariables.userRoleFromUserList];
        
        if (![Utils isEmpty:role]) {
            if([role isEqualToString:@"user"])
            {
                _rolLabel.textColor=[UIColor whiteColor];
                _rolLabel.text=@"USER";
            }else  if([role isEqualToString:@"agent"])
            {
                _rolLabel.textColor=[UIColor whiteColor];
                _rolLabel.text=@"AGENT";
            }
        }else
        {
            _rolLabel.hidden=YES;
        }
        NSString *isClientActive= [NSString stringWithFormat:@"%@",globalVariables.userStateFromUserList];
        NSString *isClientDeactive= [NSString stringWithFormat:@"%@",globalVariables.ActiveDeactiveStateOfUser1];
        [Utils isEmpty:isClientActive];
        [Utils isEmpty:isClientDeactive];
        
        if(![Utils isEmpty:isClientDeactive])
        {
            if ([isClientDeactive isEqualToString:@"1"])
            {
                _testingLAbel.textColor=[UIColor whiteColor];
                _testingLAbel.text=@"DEACTIVE";
            }
            else if (![Utils isEmpty:isClientActive]) {
                
                if ([isClientActive isEqualToString:@"1"])
                {
                    _testingLAbel.textColor=[UIColor whiteColor];
                    _testingLAbel.text=@"ACTIVE";
                }else
                {
                    _testingLAbel.textColor=[UIColor whiteColor];
                    _testingLAbel.text=@"INACTIVE";
                }
            }
            
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
        NSLog( @" I am in vidDidLoad method in ClinetDetail ViewController" );
        
    }
    
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
   // [[AppDelegate sharedAppdelegate] showProgressView];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"Loading details"];
    
    
    [self reload];
    
    
    
}


-(void)backBtnClick:(UIBarButtonItem*)item{
    
    ClientListViewController *clientList=[self.storyboard instantiateViewControllerWithIdentifier:@"clientListId"];
    
    SampleNavigation *slide = [[SampleNavigation alloc] initWithRootViewController:clientList];
    
    
    ExpandableTableViewController *sidemenu = (ExpandableTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"sideMenu"];
    
    // Initialize SWRevealViewController and set it as |rootViewController|
    SWRevealViewController * vc= [[SWRevealViewController alloc]initWithRearViewController:sidemenu frontViewController:slide];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    globalVariables=[GlobalVariables sharedInstance];
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [refresh endRefreshing];
        
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
        
       // [[AppDelegate sharedAppdelegate] hideProgressView];
          [SVProgressHUD dismiss];
        
    }else{
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/my-tickets-user?api_key=%@&ip=%@&token=%@&user_id=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],globalVariables.userIDFromUserList];
        NSLog(@"URL is : %@",url);
        NSLog(@"User id is : %@",globalVariables.userIDFromUserList);
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                
                if (error || [msg containsString:@"Error"]) {
                    
                   // [[AppDelegate sharedAppdelegate] hideProgressView];
                      [SVProgressHUD dismiss];
                    [self->refresh endRefreshing];
                    
                    if([msg isEqualToString:@"Error-402"])
                    {
                        NSLog(@"Message is : %@",msg);
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access denied - Either your role has been changed or your login credential has been changed."] sendViewController:self];
                    }
                    else if([msg isEqualToString:@"Error-500"] ||[msg isEqualToString:@"500"])
                    {
                        NSLog(@"Message is : %@",msg);
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Internal Server Error.Something has gone wrong on the website's server."] sendViewController:self];
                    }
                    else{
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                    }
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self reload];
                    NSLog(@"Thread--NO4-call-getClientTickets");
                    return;
                }
                
                if (json) {
                    
                    self->mutableArray=[[NSMutableArray alloc]initWithCapacity:10];
                    NSLog(@"Thread-NO4--getClientTickets111--%@",json);
                    
                    NSString * str= [json objectForKey:@"error"];
                    if([str isEqualToString:@"This is not a client"])
                    {
                        
                        
                        //   [utils showAlertWithMessage:@"This is not a Client" sendViewController:self];
                    }
                    
                    self->mutableArray = [[json objectForKey:@"tickets"] copy];
                    
                    if ( [self->mutableArray count] == 0){
                        
                        //   [utils showAlertWithMessage:@"User have no Tickets" sendViewController:self];
                    }
                    
                    NSDictionary *requester=[json objectForKey:@"requester"];
                    
                    self->requesterTempDict= [json objectForKey:@"requester"];
                    
                    
                    NSString *isDelete= [NSString stringWithFormat:@"%@",[requester objectForKey:@"is_delete"]];
                    
                    [Utils isEmpty:isDelete];
                    if(![Utils isEmpty:isDelete])
                    {
                        
                        if([isDelete isEqualToString:@"1"])
                        {
                            self->globalVariables.ActiveDeactiveStateOfUser1=@"deActive";
                        }
                        
                        if([isDelete isEqualToString:@"0"])
                        {
                            self->globalVariables.ActiveDeactiveStateOfUser1=@"Active";
                        }
                    }
                    else
                    {
                        NSLog(@"is_delete parameter is empty");
                    }
                    //
                    //
                    
                    
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            [self->refresh endRefreshing];
                           //[[AppDelegate sharedAppdelegate] hideProgressView];
                            [SVProgressHUD dismiss];
                            
                        });
                    });
                }
                
                //[[AppDelegate sharedAppdelegate] hideProgressView];
                [SVProgressHUD dismiss];
                NSLog(@"Thread-NO5-getClientTickets-closed");
                
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
            NSLog( @" I am in reload method in ClinetDetail ViewController" );
            
        }
        
    }
}


#pragma mark - Table view data source

//This method returns the number of rows (table cells) in a specified section.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if ([mutableArray count]==0)
    {
        self.noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        //  self.noDataLabel.text             =  @"User is Inactive or Deactivated.";
        self.noDataLabel.text             =  @"";
        
        self.noDataLabel.textColor        = [UIColor blackColor];
        self.noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tableView.backgroundView = self.noDataLabel;
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
//This method tells the delegate the table view is about to draw a cell for a particular row
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
}

//This method asks the data source to return the number of sections in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [mutableArray count];
}



// This method asks the data source for a cell to insert in a particular location of the table view.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OpenCloseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OpenCloseTableViewID"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OpenCloseTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *finaldic=[mutableArray objectAtIndex:indexPath.row];
    
    NSLog(@"Dictionary is : %@",finaldic);
    
    
    @try{
        // cell.ticketNumberLbl.text=[finaldic objectForKey:@"ticket_number"];
        
        if ( ( ![[finaldic objectForKey:@"ticket_number"] isEqual:[NSNull null]] ) && ( [[finaldic objectForKey:@"ticket_number"] length] != 0 ) )
        {
            cell.ticketNumberLbl.text=[finaldic objectForKey:@"ticket_number"];
        }
        else
        {
            cell.ticketNumberLbl.text= NSLocalizedString(@"Not Available",nil);
        }
        
        // cell.ticketSubLbl.text=[finaldic objectForKey:@"title"];
        
        //    if ( ( ![[finaldic objectForKey:@"title"] isEqual:[NSNull null]] ) && ( [[finaldic objectForKey:@"title"] length] != 0 ) )
        //    {
        //        cell.ticketSubLbl.text=[finaldic objectForKey:@"title"];
        //    }
        //    else
        //    {
        //        cell.ticketSubLbl.text= NSLocalizedString(@"Not Available",nil);
        //    }
        
        NSString *encodedString =[finaldic objectForKey:@"title"];
        
        [Utils isEmpty:encodedString];
        
        if  ([Utils isEmpty:encodedString]){
            cell.ticketSubLbl.text=@"No Title";
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
                cell.ticketSubLbl.text= [NSString stringWithFormat:@"%@",decodedString];
                
            }
            else{
                
                // cell.ticketSubLabel.text= encodedString;
                cell.ticketSubLbl.text= [NSString stringWithFormat:@"%@",encodedString];
                
            }
            
        }
        ///////////////////////////////////////////////////
        
        
        
        
        
        
        
        if ([[finaldic objectForKey:@"ticket_status_name"] isEqualToString:@"Open"]) {
            cell.indicationView.layer.backgroundColor=[[UIColor hx_colorWithHexRGBAString:SUCCESS_COLOR] CGColor];
        }else{
            cell.indicationView.layer.backgroundColor=[[UIColor hx_colorWithHexRGBAString:FAILURE_COLOR] CGColor];
            
        }
    }@catch (NSException *exception)
    {
        
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        [utils showAlertWithMessage:exception.name sendViewController:self];
        // return;
    }
    @finally
    {
        NSLog( @" I am in CellForAtIndexPath method in CLinetDetail ViewController" );
        
    }
    
    return cell;
}

// After clicking on edit button, it will naviagte to edit user details page
-(void)EditClientProfileMethod
{
    
    ClientEditDetailsView *edit=[self.storyboard instantiateViewControllerWithIdentifier:@"clientEditDetailsId"];
    
    [self.navigationController pushViewController:edit animated:YES];
    
    
}

// This method tells the delegate that the specified row is now deselected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TicketDetailViewController *td=[self.storyboard instantiateViewControllerWithIdentifier:@"ticketDetailViewId"];
    NSDictionary *finaldic=[mutableArray objectAtIndex:indexPath.row];



    globalVariables.ticketId=[finaldic objectForKey:@"id"];
    globalVariables.ticketNumber=[finaldic objectForKey:@"ticket_number"];

    //globalVariables.title=[finaldic objectForKey:@"title"];  // ticket_status_name  // Ticket_status

    globalVariables.ticketStatus= [finaldic objectForKey:@"ticket_status_name"];

    //requesterTempDict
    globalVariables.firstNameFromTicket= [requesterTempDict objectForKey:@"first_name"];
    globalVariables.lastNameFromTicket= [requesterTempDict objectForKey:@"last_name"];


    [self.navigationController pushViewController:td animated:YES];
    
}

// This method used to show refresh behind the table view.
-(void)addUIRefresh{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *refreshing = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refreshing",nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle,NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    refresh=[[UIRefreshControl alloc] init];
    refresh.tintColor=[UIColor whiteColor];
    refresh.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    refresh.attributedTitle =refreshing;
    [refresh addTarget:self action:@selector(reloadd) forControlEvents:UIControlEventValueChanged];
    [_tableView insertSubview:refresh atIndex:0];
    
}

-(void)reloadd{
    [self reload];
    //[refresh endRefreshing];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Calculate cell height
    return 65.0f;
}

-(void)setUserProfileimage:(NSString*)imageUrl
{
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                             placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
}




@end
