//
//  ConversationViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 08/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationTableViewCell.h"
#import "Utils.h"
#import "Reachability.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "HexColors.h"
#import "GlobalVariables.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "UIImageView+Letters.h"
#import "AttachmentViewController.h"
#import "InboxTickets.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"


@interface ConversationViewController ()<ConversationTableViewCellDelegate,UIWebViewDelegate,RMessageProtocol>
{
    Utils *utils;
    NSUserDefaults *userDefaults;
    NSMutableArray *mutableArray;
    GlobalVariables *globalVariable;
    int selectedIndex;
    NSMutableArray *attachmentArray;
    
    NSString *fName;
    NSString *lName;
    NSString *userName;
    
    InboxTickets * inboxPage;
}
@property(nonatomic,strong) UILabel *noDataLabel;

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndex = -1;
    
    [SVProgressHUD showWithStatus:@"Loading details"];
    
    //[self.view addSubview:_activityIndicatorObject];
    [self addUIRefresh];
    utils=[[Utils alloc]init];
    globalVariable=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    inboxPage=[[InboxTickets alloc]init];
    
    attachmentArray=[[NSMutableArray alloc]init];
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadd) name:@"reload_data" object:nil];
    
    [self reload];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method calls an API for getting tickets, it will returns an JSON which contains 10 records with ticket details.
-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self.refreshControl endRefreshing];
        
        //[[AppDelegate sharedAppdelegate] hideProgressView];
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
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/ticket-thread?api_key=%@&ip=%@&token=%@&id=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],globalVariable.ticketId];
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                if (error || [msg containsString:@"Error"]) {
                    [self.refreshControl endRefreshing];
                    [SVProgressHUD dismiss];
                    //[[AppDelegate sharedAppdelegate] hideProgressView];
                    
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
                            else if([msg isEqualToString:@"Error-403"] || [msg isEqualToString:@"403"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:@"Access Denied. Either your credentials has been changed or You are not an Agent/Admin." sendViewController:self];
                            }
                            else{
                                
                                [self->utils showAlertWithMessage:msg sendViewController:self];
                            }
                        
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self reload];
                    NSLog(@"Thread--NO4-call-getConversation");
                    return;
                }
                
                if ([msg isEqualToString:@"tokenNotRefreshed"]) {
                    
                    [self showMessageForLogout:@"Your HELPDESK URL or Your Login credentials were changed, contact to Admin and please log back in." sendViewController:self];
                    
                    //[[AppDelegate sharedAppdelegate] hideProgressView];
                    [SVProgressHUD dismiss];
                    
                    return;
                }
                
                if (json) {
                    //NSError *error;
                    
                    self->mutableArray=[[NSMutableArray alloc]initWithCapacity:10];
                    
                    NSDictionary *dataConversationDict=[json objectForKey:@"data"];
                   // NSLog(@"DIct11111 is : %@",dataConversationDict);
                    
                    self->mutableArray=[dataConversationDict objectForKey:@"threads"];
                    
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            [self.refreshControl endRefreshing];
                            [SVProgressHUD dismiss];
                           
                        });
                    });
                }
                [SVProgressHUD dismiss];
                NSLog(@"Thread-NO5-getConversation-closed");
                
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
            NSLog( @" I am in reload method in Conversation ViewController" );
            
        }
        
        
    }
}



//This method asks the data source to return the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if ([mutableArray count]==0)
    {
        self.noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        //self.noDataLabel.text             = NSLocalizedString(@"Empty!!!",nil);
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
    
    ConversationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ConvTableViewCell"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConversationTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setDelegate:self];
    
    NSDictionary *finaldic=[mutableArray objectAtIndex:indexPath.row];
    //NSLog(@"Ticket Thread Dict is : %@",finaldic);
    
    
    
    attachmentArray=[finaldic objectForKey:@"attach"];
    
    
//        globalVariable=[GlobalVariables sharedInstance];
//        globalVariable.attachArrayFromConversation=attachmentArray;
    
    if ([attachmentArray count] != 0){
        
        cell.attachImage.hidden=NO;
        cell.attachButtonLabel.hidden=NO;
        
        
        
        for (int i = 0; i < attachmentArray.count; i++) {
            globalVariable.attachArrayFromConversation=attachmentArray;
            
            NSDictionary *attachDictionary=[attachmentArray objectAtIndex:i];
            
            
            //    NSString *numStr = [NSString stringWithFormat:@"%@", [attachDictionary objectForKey:@"file"]];
            
            NSString *fileName=[attachDictionary objectForKey:@"name"];
            NSString *fileSize=[NSString stringWithFormat:@"%@",[attachDictionary objectForKey:@"size"]];
            NSString *fileType=[attachDictionary objectForKey:@"type"];
            
            NSLog(@"File Name : %@",fileName);
            NSLog(@"File size : %@",fileSize);
            NSLog(@"File Type : %@",fileType);
            
            //  printf("File Attachemnt(base64 String) : %s\n", [numStr UTF8String]);
        }
        
        //        NSIndexPath *path;
        //        NSDictionary *attachDictionary=[attachmentArray objectAtIndex:path.row];
        ////        //   NSLog(@"Attchment Dict is: %@",attachDictionary);
        //
        //
        //         NSString *numStr = [NSString stringWithFormat:@"%@", [attachDictionary objectForKey:@"file"]];
        //
        //         NSString *fileName=[attachDictionary objectForKey:@"name"];
        //         NSString *fileSize=[NSString stringWithFormat:@"%@",[attachDictionary objectForKey:@"size"]];
        //         NSString *fileType=[attachDictionary objectForKey:@"type"];
        //
        //         NSLog(@"File Name : %@",fileName);
        //         NSLog(@"File size : %@",fileSize);
        //         NSLog(@"File Type : %@",fileType);
        //
        //         printf("File Attachemnt(base64 String) : %s\n", [numStr UTF8String]);
        
    } else
    {
        NSLog(@"EMpty aaray");
        cell.attachImage.hidden=YES;
        cell.attachButtonLabel.hidden=YES;
    }
    
    
    //created at time
    cell.timeStampLabel.text=[utils getLocalDateTimeFromUTC:[finaldic objectForKey:@"created_at"]];
    
    //internal note label
    NSInteger i=[[finaldic objectForKey:@"is_internal"] intValue];
    if (i==0) {
        [cell.internalNoteLabel setHidden:YES];
    }
    if(i==1){
        [cell.internalNoteLabel setHidden:NO];
    }
    
    
    
    //         NSURL *url = [NSURL URLWithString:@"http://www.amazon.com"];
    //        [cell.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    // NSDictionary *finaldic=[mutableArray objectAtIndex:indexPath.row];
    //    [self showWebview:@"" body:[finaldic objectForKey:@"body"] popupStyle:CNPPopupStyleActionSheet];/
    
    
    NSString *body= [finaldic objectForKey:@"body"];  //@"Mallikarjun";
    NSRange range = [body rangeOfString:@"<body"];
    
    if(range.location != NSNotFound) {
        // Adjust style for mobile
        float inset = 40;
        NSString *style = [NSString stringWithFormat:@"<style>div {max-width: %fpx;}</style>", self.view.bounds.size.width - inset];
        body = [NSString stringWithFormat:@"%@%@%@", [body substringToIndex:range.location], style, [body substringFromIndex:range.location]];
    }
    cell.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.webView loadHTMLString:body baseURL:nil];
    
    
    
    if([NSNull null] != [finaldic objectForKey:@"user"])
    {
        NSDictionary *userData=[finaldic objectForKey:@"user"];
        
        fName=[userData objectForKey:@"first_name"];
        lName=[userData objectForKey:@"last_name"];
        userName=[userData objectForKey:@"user_name"];
        NSString *userProfilePic=[userData objectForKey:@"profile_pic"];
        
        [Utils isEmpty:fName];
        [Utils isEmpty:lName];
        [Utils isEmpty:userName];
        [Utils isEmpty:userProfilePic];
        
        
        if  ([Utils isEmpty:fName] && [Utils isEmpty:lName]){
            if(![Utils isEmpty:userName]){
                userName=[NSString stringWithFormat:@"%@",userName];
                cell.clientNameLabel.text=userName;
            }else cell.clientNameLabel.text=@"System";
        }
        else if ((![Utils isEmpty:fName] || ![Utils isEmpty:lName]) || (![Utils isEmpty:fName] && ![Utils isEmpty:lName]))
        {
            NSString * fName12=[NSString stringWithFormat:@"%@ %@",fName,lName];
            
            cell.clientNameLabel.text=fName12;
            
        }
        
        
    
        if([userProfilePic hasSuffix:@"system.png"] || [userProfilePic hasSuffix:@".jpg"] || [userProfilePic hasSuffix:@".jpeg"] || [userProfilePic hasSuffix:@".png"] )
        {
            [cell setUserProfileimage:userProfilePic];
        }
        else if(![Utils isEmpty:fName])
        {
            [cell.profilePicView setImageWithString:fName color:nil ];
        }
        else if(![Utils isEmpty:userName])
        {
            [cell.profilePicView setImageWithString:userName color:nil ];
        }
        
        
        
    }
    else
    {
        cell.clientNameLabel.text=@"System";
        cell.profilePicView.image=[UIImage imageNamed:@"robot"];
        // [cell.profilePicView setImageWithString:@"System" color:nil ];
    }
    
    
    return cell;
}

// After clickin on attachment button on tableview row which contains attachments, it will navigate to view attachment controller.
- (void) buttonTouchedForCell:(ConversationTableViewCell *)cell {
    
   [SVProgressHUD showWithStatus:@"Please wait"];
    
    globalVariable.attachArrayFromConversation=globalVariable.attachArrayFromConversation;
    AttachmentViewController *attach=[self.storyboard instantiateViewControllerWithIdentifier:@"attachmentViewId"];
    [self.navigationController pushViewController:attach animated:YES];
}

//This method asks the delegate for the height to use for a row in a specified location.
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(selectedIndex == indexPath.row)
    {
        // return  200;
        
        UITableViewCell   *cell = [self tableView: tableView cellForRowAtIndexPath: indexPath];
        return cell.bounds.size.height;
    }
    else
    {
        return  90;
    }
}

// This method tells the delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //user taps expnmade view
    
    if(selectedIndex == indexPath.row)
    {
        
        selectedIndex =-1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]  withRowAnimation:UITableViewRowAnimationFade ];
        return;
    }
    
    //user taps diff row
    if(selectedIndex != -1)
    {
        
        NSIndexPath *prevPath= [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex=(int)indexPath.row;
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:prevPath, nil]  withRowAnimation:UITableViewRowAnimationFade ];
    }
    
    
    //uiser taps new row with none expanded
    selectedIndex =(int)indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]  withRowAnimation:UITableViewRowAnimationFade ];
    
}


// This method used to show refresh behind the table view.
-(void)addUIRefresh{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *refreshing = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refreshing",nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle,NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor=[UIColor whiteColor];
    //  self.refreshControl.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    self.refreshControl.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#BDBDBD"];
    
    self.refreshControl.attributedTitle =refreshing;
    [self.refreshControl addTarget:self action:@selector(reloadd) forControlEvents:UIControlEventValueChanged];
    
}

-(void)reloadd{
    [self reload];
    // [refreshControl endRefreshing];
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
            [SVProgressHUD dismiss];
        }
        
    }];
    
}



@end
