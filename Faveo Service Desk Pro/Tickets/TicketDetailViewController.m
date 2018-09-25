//
//  TicketDetailViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "TicketDetailViewController.h"
#import "Utils.h"
#import "HexColors.h"
#import "AppConstanst.h"
#import "Reachability.h"
#import "MyWebservices.h"
#import "GlobalVariables.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "FTPopOverMenu.h"
#import "UIColor+HexColors.h"
#import "ConversationViewController.h"
#import "EditTicketDetails.h"
#import "ReplyTicketViewController.h"
#import "InternalNoteViewController.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "InboxTickets.h"
#import "LPSemiModalView.h"
#import "AssetCell.h"
#import "CreateProblem.h"
#import "BIZPopupViewController.h"


@interface TicketDetailViewController () <RMessageProtocol,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    Utils *utils;
    NSUserDefaults *userDefaults;
    UITextField *textFieldCc;
    UITextView *textViewInternalNote;
    UITextView *textViewReply;
    UILabel *errorMessageReply;
    UILabel *errorMessageNote;
    GlobalVariables *globalVariables;
    
    
    NSArray *ticketStatusArray;
    
    
    NSMutableArray *statusArrayforChange;
    NSMutableArray *statusIdforChange;
    NSMutableArray *uniqueStatusNameArray;
    NSString *selectedStatusName;
    NSString *selectedStatusId;
}

@property (nonatomic, strong) LPSemiModalView *normalModalView1;
@property (nonatomic, strong) LPSemiModalView *normalModalView2;

@property (strong, nonatomic) UITableView *tableView1;

@property (nonatomic) int count1;

@end

@implementation TicketDetailViewController

//This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView method.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConversationVC"];
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
   
    
    //  self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    
    statusArrayforChange = [[NSMutableArray alloc] init];
    statusIdforChange = [[NSMutableArray alloc] init];
    uniqueStatusNameArray = [[NSMutableArray alloc] init];
    
    self.segmentedControl.tintColor=[UIColor hx_colorWithHexRGBAString:@"#00aeef"];
    
    UIButton *editTicket =  [UIButton buttonWithType:UIButtonTypeCustom]; // editTicket
    
    [editTicket setImage:[UIImage imageNamed:@"pencileEdit"] forState:UIControlStateNormal];
    [editTicket addTarget:self action:@selector(editTicketTapped) forControlEvents:UIControlEventTouchUpInside];
    // [editTicket setFrame:CGRectMake(0, 0, 32, 32)];
    [editTicket setFrame:CGRectMake(10, 7, 20, 20)];
    
    UIButton *moreButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"verticle"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(onNavButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setFrame:CGRectMake(44, 0, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:moreButton];
    [rightBarButtonItems addSubview:editTicket];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    NSLog(@"Ticket Id isssss : %@",globalVariables.ticketId);
    
    // this is showing tableview pop-up for problems
    self.tableview.separatorColor=[UIColor clearColor];
    
    // ************** modal view 1 for showing assets ************************
    
    self.normalModalView1 = [[LPSemiModalView alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, 230) andBaseViewController:self];
    //  self.normalModalView.contentView.backgroundColor = [UIColor yellowColor];
    
    
    // init table view
    _tableView1 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    
    // _tableView1.backgroundColor = [UIColor lightGrayColor];
    
    // add to canvas
    [self.normalModalView1.contentView addSubview:_tableView1];
    
    
    // creating header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(1, 50, 276, 45)];
    // headerView.backgroundColor = [UIColor colorFromHexString:@"EFEFF4"];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(8, 13, 300, 24)];
    labelView.text = @"Asssociated Assets";
    //  labelView.textColor = [UIColor colorFromHexString:@"CCCCCC"];
    labelView.textColor = [UIColor whiteColor];
    
    [headerView addSubview:labelView];
    _tableView1.tableHeaderView = headerView;
    
    // end creating header
    
    
    self.normalModalView1.narrowedOff = YES;
    self.normalModalView1.backgroundColor = [UIColor whiteColor];
    
    
   // ************** end modal view 1 for showing assets ***********************
    
   // **************** modal view 2 for problem ********************************
    
    self.normalModalView2 = [[LPSemiModalView alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, 150) andBaseViewController:self];
    //  self.normalModalView.contentView.backgroundColor = [UIColor yellowColor];
    
    
    UILabel *label0;
    UILabel *label1;
    UILabel *label2;
    
    //  x  y    w   h
    label0=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 220, 13)];
    label1=[[UILabel alloc]initWithFrame:CGRectMake(53, 50, 220, 40)];//Set frame of label in your viewcontroller.
    label2=[[UILabel alloc]initWithFrame:CGRectMake(53, 90, 220, 40)];
    
    
    [label1 setText:@"Attach New Problem"];//Set text in label.
    [label2 setText:@"Attach Existing Problem"];
    [label0 setText:@"..."];
    
    label1.userInteractionEnabled = YES;
    label2.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attachNewProblemClicked)];
    UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attachExistingProblemClicked)];
    
    [label1 addGestureRecognizer:tapGesture1];
    [label2 addGestureRecognizer:tapGesture2];
    
    [label0 setTextColor:[UIColor colorFromHexString:@"CCCCCC"]];
    [label1 setTextColor:[UIColor blackColor]];//Set text color in label.
    [label2 setTextColor:[UIColor blackColor]];
    
    [label0 setTextAlignment:NSTextAlignmentLeft];
    [label1 setTextAlignment:NSTextAlignmentLeft];//Set text alignment in label.
    [label1 setTextAlignment:NSTextAlignmentLeft];//Set text alignment in label.
    
    [label1 setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [label1 setLineBreakMode:NSLineBreakByCharWrapping];//Set linebreaking mode..
    // [label setNumberOfLines:1];//Set number of lines in label.
    
    [self.normalModalView2.contentView addSubview:label0];
    [self.normalModalView2.contentView addSubview:label1];
    [self.normalModalView2.contentView addSubview:label2];
    
    
    
    UIImageView *imageview1 = [[UIImageView alloc]
                               initWithFrame:CGRectMake(16, 59, 25, 25)];
    [imageview1 setImage:[UIImage imageNamed:@"create_ticket"]];
    [imageview1 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView2.contentView addSubview:imageview1];
    
    UIImageView *imageview2 = [[UIImageView alloc]
                               initWithFrame:CGRectMake(16, 98, 25, 25)];
    [imageview2 setImage:[UIImage imageNamed:@"AddCC"]];
    [imageview2 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView2.contentView addSubview:imageview2];
    
    
    self.normalModalView2.narrowedOff = YES;
   
    // **************** end modal view 2 for problem *************************************
    
    
    
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
        
        [self getDependencies];
        [self getProblemAssociatedProblemDetails];
    }
    
}


//This method is called before the view controller's view is about to be added to a view hierarchy and before any animations are configured for showing the view.
-(void)viewWillAppear:(BOOL)animated
{
    
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    _ticketLabel.text=globalVariables.ticketNumber;
    
    _nameLabel.text=[NSString stringWithFormat:@"%@ %@",globalVariables.firstNameFromTicket,globalVariables.lastNameFromTicket];
    
    _statusLabel.text=globalVariables.ticketStatus;
    
    
    [super viewWillAppear:animated];
    
   
}

// After clicking this button, it will nviagte to edit ticket view controller
-(void)editTicketTapped
{
    NSLog(@"EditTicket Tapped"); // EditDetailTableViewController.h
    
    EditTicketDetails *edit= [self.storyboard instantiateViewControllerWithIdentifier:@"editTicketDetailsId"];
    [self.navigationController pushViewController:edit animated:YES];
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if(item.tag == 1) {
        //your code for tab item 1
        NSLog(@"clicked on 1");
        
        [self.normalModalView1 open];
        
    }
    else if(item.tag == 2) {
        //your code for tab item 2
        NSLog(@"clicked on 2");
        
        if([globalVariables.problemStatusInTicketDetailVC isEqualToString:@"notFound"]){
            
            NSLog(@"Problem Not Found");
            [self.normalModalView2 open];
        }
        else if([globalVariables.problemStatusInTicketDetailVC isEqualToString:@"Found"]){
            
            NSLog(@"Problem Found");
            
        }
        
    }
    else if(item.tag == 3) {
        //your code for tab item 3
        NSLog(@"clicked on 3");
        
        ReplyTicketViewController *reply=[self.storyboard instantiateViewControllerWithIdentifier:@"replyTicketViewId"];
        [self.navigationController pushViewController:reply animated:YES];
        
    }
    else if(item.tag == 4) {
        //your code for tab item 4
        NSLog(@"clicked on 4");
        
        InternalNoteViewController * note=[self.storyboard instantiateViewControllerWithIdentifier:@"internalNoteViewId"];
        [self.navigationController pushViewController:note animated:YES];
        
    }
    else{
        
        NSLog(@"something went wrong");
        
    }
}



- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}


- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    newViewController.view.alpha = 0;
    [newViewController.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                     }];
}

// This method used to get some values like Agents list, Ticket Status, Ticket counts, Ticket Source, SLA ..etc which are used in various places in project.
-(void)getDependencies{
    
   
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
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/dependency?api_key=%@&ip=%@&token=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"]];
        
        NSLog(@"URL is : %@",url);
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg){
                //   NSLog(@"Thread-NO3-getDependencies-start-error-%@-json-%@-msg-%@",error,json,msg);
                
                if (error || [msg containsString:@"Error"]) {
                    
                  //  [[AppDelegate sharedAppdelegate] hideProgressView];
                    [SVProgressHUD dismiss];
                    
                    if( [msg containsString:@"Error-401"])
                        
                    {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Your Credential Has been changed"] sendViewController:self];
                        
                        
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
                            NSLog(@"Thread-NO4-getdependency-Refresh-error == %@",error.localizedDescription);
                            [self->utils showAlertWithMessage:msg sendViewController:self];
                            
                            
                            return ;
                        }
                }
                
                
                // [[AppDelegate sharedAppdelegate] hideProgressView];
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self getDependencies];
                    NSLog(@"Thread--NO4-call-getDependecies");
                    return;
                }
                
                if (json) {
                    
                  //  NSLog(@"Thread-NO4-getDependencies-dependencyAPI--%@",json);
                 //   NSLog(@"Thread-NO4-getDependencies-dependencyAPI--%@",json);
                    NSDictionary *resultDic = [json objectForKey:@"data"];
                    NSArray *ticketCountArray=[resultDic objectForKey:@"tickets_count"];
                    
                    for (int i = 0; i < ticketCountArray.count; i++) {
                        NSString *name = [[ticketCountArray objectAtIndex:i]objectForKey:@"name"];
                        NSString *count = [[ticketCountArray objectAtIndex:i]objectForKey:@"count"];
                        if ([name isEqualToString:@"Open"]) {
                            self->globalVariables.OpenCount=count;
                            
                        }else if ([name isEqualToString:@"Closed"]) {
                            self->globalVariables.ClosedCount=count;
                        }else if ([name isEqualToString:@"Deleted"]) {
                            self->globalVariables.DeletedCount=count;
                        }else if ([name isEqualToString:@"unassigned"]) {
                            self->globalVariables.UnassignedCount=count;
                        }else if ([name isEqualToString:@"mytickets"]) {
                            self->globalVariables.MyticketsCount=count;
                        }
                    }
                    
                    self->ticketStatusArray=[resultDic objectForKey:@"status"];
        
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
                    
                    // get documents path
                    NSString *documentsPath = [paths objectAtIndex:0];
                    
                    // get the path to our Data/plist file
                    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"faveoData.plist"];
                    NSError *writeError = nil;
                    
                    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:resultDic format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListImmutable error:&writeError];
                    
                    if(plistData)
                    {
                        [plistData writeToFile:plistPath atomically:YES];
                        NSLog(@"Data saved sucessfully");
                    }
                    else
                    {
                       // NSLog(@"Error in saveData: %@", writeError.localizedDescription);
                        
                    }
                    
                }
                NSLog(@"Thread-NO5-getDependencies-closed");
            }
             ];
        }@catch (NSException *exception)
        {
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            [utils showAlertWithMessage:exception.name sendViewController:self];
           //[AppDelegate sharedAppdelegate] hideProgressView];
            [SVProgressHUD dismiss];
            return;
        }
        @finally
        {
            NSLog( @" I am in getDependencies method in ticket detail ViewController" );
            
            
        }
    }
    NSLog(@"Thread-NO2-getDependencies()-closed");
}


 //This method used to show some popuop or list which contain some menus. Here it used to change the status of ticket, after clicking this button it will show one view which contains list of status. After clicking on any row, according to its name that status will be changed.
-(void)onNavButtonTapped:(UIBarButtonItem *)sender event:(UIEvent *)event
{

#ifdef IfMethodOne
    CGRect rect = [self.navigationController.navigationBar convertRect:[event.allTouches.anyObject view].frame toView:[[UIApplication sharedApplication] keyWindow]];

    [FTPopOverMenu showFromSenderFrame:rect
                         withMenuArray:@[@"MenuOne",@"MenuTwo",@"MenuThree",@"MenuFour"]
                            imageArray:@[@"Pokemon_Go_01",@"Pokemon_Go_02",@"Pokemon_Go_03",@"Pokemon_Go_04",]
                             doneBlock:^(NSInteger selectedIndex) {
                                 NSLog(@"done");
                             } dismissBlock:^{
                                 NSLog(@"cancel");
                             }];


#else


    //taking status names array for dependecy api
    for (NSDictionary *dicc in self->ticketStatusArray) {
        if ([dicc objectForKey:@"name"]) {
            [self->statusArrayforChange addObject:[dicc objectForKey:@"name"]];
            [self->statusIdforChange addObject:[dicc objectForKey:@"id"]];
        }

    }


    //removing duplicated status names
    for (id obj in self->statusArrayforChange) {
        if (![uniqueStatusNameArray containsObject:obj]) {
            [uniqueStatusNameArray addObject:obj];
        }
    }

    [FTPopOverMenu showFromEvent:event
                   withMenuArray:uniqueStatusNameArray
                      imageArray:uniqueStatusNameArray
                       doneBlock:^(NSInteger selectedIndex) {


                           self->selectedStatusName=[self->uniqueStatusNameArray objectAtIndex:selectedIndex];
                           NSLog(@"Status is : %@",self->selectedStatusName);


                           for (NSDictionary *dic in self->ticketStatusArray)
                           {
                               NSString *idOfStatus = dic[@"name"];

                               if([idOfStatus isEqual:self->selectedStatusName])
                               {
                                   self->selectedStatusId= dic[@"id"];

                                   NSLog(@"id is : %@",self->selectedStatusId);
                               }
                           }

                           if([self->selectedStatusName isEqualToString:self->globalVariables.ticketStatus])
                           {
                               NSString * msg=[NSString stringWithFormat:@"Ticket is Already %@.",self->globalVariables.ticketStatus];
                               [self->utils showAlertWithMessage:msg sendViewController:self];
                              [SVProgressHUD dismiss];
                           }

                           else{
                               [self askConfirmationForStatusChange];
                               //  [self changeStatusMethod:self->selectedStatusName idIs:self->selectedStatusId];
                           }

                       }
                    dismissBlock:^{

                    }];

#endif

}


-(void)askConfirmationForStatusChange
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Ticket Status"
                                 message:@"are you sure you want to change ticket status?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"No"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   
                                   [self changeStatusMethod:self->selectedStatusName idIs:self->selectedStatusId];
                                   
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)changeStatusMethod:(NSString *)nameOfStatus idIs:(NSString *)idOfStatus
{
    
    NSLog(@"Status Name is : %@",nameOfStatus);
    NSLog(@"Id is : %@",idOfStatus);
    
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
        
        [SVProgressHUD showWithStatus:@"Changing status"];
        
        
        NSString *url= [NSString stringWithFormat:@"%@api/v2/helpdesk/status/change?api_key=%@&token=%@&ticket_id=%@&status_id=%@",[userDefaults objectForKey:@"baseURL"],API_KEY,[userDefaults objectForKey:@"token"],globalVariables.ticketId,idOfStatus];
        NSLog(@"URL is : %@",url);
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        
        [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
         [SVProgressHUD dismiss];
            
            if (error || [msg containsString:@"Error"]) {
                
                if (msg) {
                    
                    if([msg isEqualToString:@"Error-403"])
                    {
                        [self->utils showAlertWithMessage:NSLocalizedString(@"Permission Denied - You don't have permission to change ticket status. ", nil) sendViewController:self];
                    }
                    else{
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                    }
                    //  NSLog(@"Message is : %@",msg);
                    
                }else if(error)  {
                    [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                    NSLog(@"Thread-NO4-getTicketStausChange-Refresh-error == %@",error.localizedDescription);
                }
                
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                [self changeStatusMethod:self->selectedStatusName idIs:self->selectedStatusId];
                NSLog(@"Thread--NO4-call-postTicketStatusChange");
                return;
            }
            
            if (json) {
                NSLog(@"JSON-Status-Change-Close-%@",json);
                
                
                if([[json objectForKey:@"message"] isKindOfClass:[NSArray class]])
                {
                    [self->utils showAlertWithMessage:NSLocalizedString(@"Permission Denied - You don't have permission to change status. ", nil) sendViewController:self];
                    
                }
                else{
                    
                    NSString * msg=[json objectForKey:@"message"];
                    
                    if([msg hasPrefix:@"Status changed"]){
                        
                    
                        if (self.navigationController.navigationBarHidden) {
                            [self.navigationController setNavigationBarHidden:NO];
                        }
                        
                        [RMessage showNotificationInViewController:self.navigationController
                                                             title:NSLocalizedString(@"success.",nil)
                                                          subtitle:NSLocalizedString(@"Ticket Status Changed.",nil)
                                                         iconImage:nil
                                                              type:RMessageTypeSuccess
                                                    customTypeName:nil
                                                          duration:RMessageDurationAutomatic
                                                          callback:nil
                                                       buttonTitle:nil
                                                    buttonCallback:nil
                                                        atPosition:RMessagePositionNavBarOverlay
                                              canBeDismissedByUser:YES];
                        
                        
                       InboxTickets  *inboxVC=[self.storyboard instantiateViewControllerWithIdentifier:@"inboxId"];
                        [self.navigationController pushViewController:inboxVC animated:YES];
                        
                    }else
                    {
                        
                        [self->utils showAlertWithMessage:NSLocalizedString(@"Permission Denied - You don't have permission to change status. ", nil) sendViewController:self];
                        [SVProgressHUD dismiss];
                        
                    }
                    
                }
            }
            
            NSLog(@"Thread-NO5-postTicketStatusChange-closed");
            
        }];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// It will handle segmented control selection
- (IBAction)indexChanged:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConversationVC"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    } else {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    }
    
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"faveoData.plist"];
    NSError *error;
    
    if(![[NSFileManager defaultManager] removeItemAtPath:plistPath error:&error])
    {
        NSLog(@"Error while removing the plist %@", error.localizedDescription);
        //TODO: Handle/Log error
    }
    
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





#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    
    return 1;
    
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    
   //     return [globalVariables.asstArray count];
      return 3;
}


// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    AssetCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"assetCellID"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AssetCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //     NSLog(@"Asset Array is : %@",globalVariables.asstArray);
    //
    //    NSDictionary * assetDict = [globalVariables.asstArray objectAtIndex:indexPath.row];
    //
    //    NSString * id1 = [assetDict objectForKey:@"id"];
    //    NSString *name = [assetDict objectForKey:@"name"];
    
    //    cell.assetIdLabel.text = [NSString stringWithFormat:@"#AST-%@",id1];
    //    cell.assetTitleLabel.text = [NSString stringWithFormat:@"%@",name];
    
    cell.assetIdLabel.text = [NSString stringWithFormat:@"#AST-12"];
    cell.assetTitleLabel.text = [NSString stringWithFormat:@"Pankaj Macbook Pro"];
    
    return cell;
    
}


#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Calculate cell height
    return 65.0f;
}


-(void)attachNewProblemClicked{
    
    NSLog(@"Clicked on attach new problem"); //globalVariables.ticketId
    
    globalVariables.ticketIdForTicketDetail =[NSString stringWithFormat:@"%@",globalVariables.ticketId];
    
    globalVariables.createProblemConditionforVC = @"newWithTicket";
    
    CreateProblem *createProblemVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CreateProblemId"];
    [self.navigationController pushViewController:createProblemVC animated:YES];
    
    [self.normalModalView2 close];
    
}


-(void)attachExistingProblemClicked{
    
     NSLog(@"Clicked on attach existing problem");
    
    
    
     [self.normalModalView2 close];
}

-(void)getProblemAssociatedProblemDetails{
    
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
        
        NSString *url=[NSString stringWithFormat:@"%@servicedesk/attached/problem/details/%@?api_key=%@&token=%@",[userDefaults objectForKey:@"companyURL"],globalVariables.ticketId,API_KEY,[userDefaults objectForKey:@"token"]];
        
        NSLog(@"URL is : %@",url);
        
        @try{
            
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg){
                //   NSLog(@"Thread-NO3-getDependencies-start-error-%@-json-%@-msg-%@",error,json,msg);
                
                if (error || [msg containsString:@"Error"]) {
                    
                
                    [SVProgressHUD dismiss];
                    
                    if( [msg containsString:@"Error-401"])
                        
                    {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Your Credential Has been changed"] sendViewController:self];
                        
                        
                    }
                    else
                        
                    
                        if([msg isEqualToString:@"Error-404"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"The requested URL was not found on this server."] sendViewController:self];
                            
                        }
                    
                    else{
                            NSLog(@"Error message is %@",msg);
                            NSLog(@"Thread-NO4-getdependency-Refresh-error == %@",error.localizedDescription);
                            [self->utils showAlertWithMessage:msg sendViewController:self];
                            
                            
                            return ;
                        }
                }
                
                
    
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self getProblemAssociatedProblemDetails];
                    NSLog(@"Thread-getProblemAssociatedProblemDetails-call");
                    return;
                }
                
                if (json) {
                    
                 //   NSLog(@"JSON is : %@",json);
                    
                    if (([[json objectForKey:@"data"] isEqual:[NSNull null]] ) || ( [[json objectForKey:@"data"] length] == 0 )) {
                        NSLog(@"No Problem is found");
                        // data is not available
                        self->globalVariables.problemStatusInTicketDetailVC = @"notFound";
                    }
                    else{
                     
                        NSLog(@"Problem is found");
                        self->globalVariables.problemStatusInTicketDetailVC = @"Found";
                        // data vailable
                        
                    NSDictionary * dataDict = [json objectForKey:@"data"];
                        NSLog(@"Problem Details : %@",dataDict);
                    
//                    NSString * id1 = [dataDict objectForKey:@"id"];
//                    NSString * subject = [dataDict objectForKey:@"subject"];
//                    NSString * from =  [dataDict objectForKey:@"from"];
                  
                    }
                }
                
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
        
    }
  
    
}

@end
