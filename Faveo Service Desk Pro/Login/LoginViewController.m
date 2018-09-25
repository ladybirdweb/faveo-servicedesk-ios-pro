//
//  LoginViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 21/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+HexColors.h"
#import "Utils.h"
#import "GlobalVariables.h"
#import "Reachability.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "InboxTickets.h"
#import "SampleNavigation.h"
#import "ExpandableTableViewController.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "RMessage.h"
#import "RMessageView.h"


@import FirebaseInstanceID;
@import FirebaseMessaging;
@import Firebase;


@interface LoginViewController ()<UITextFieldDelegate,RMessageProtocol>
{
    Utils *utils;
    NSUserDefaults *userdefaults;
    GlobalVariables *globalVariables;
    
    NSString *errorMsg;
    NSString *baseURL;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     utils=[[Utils alloc]init];
     userdefaults=[NSUserDefaults standardUserDefaults];
     globalVariables=[GlobalVariables sharedInstance];
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // done button on keyboard was not working so here is solution
    [self.urlTextfield setDelegate:self];
    [self.urlTextfield setReturnKeyType:UIReturnKeyDone];
    [self.urlTextfield addTarget:self action:@selector(textFieldFinished:)forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.userNameTextField setDelegate:self];
    [self.userNameTextField setReturnKeyType:UIReturnKeyDone];
    [self.userNameTextField addTarget:self
                               action:@selector(textFieldFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.passcodeTextField setDelegate:self];
    [self.passcodeTextField setReturnKeyType:UIReturnKeyDone];
    [self.passcodeTextField addTarget:self
                               action:@selector(textFieldFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // end solution
    
    // setting go button instead of next or donw on keyboard
    [_urlTextfield setReturnKeyType:UIReturnKeyGo];
    [_userNameTextField setReturnKeyType:UIReturnKeyDone];
    [_passcodeTextField setReturnKeyType:UIReturnKeyDone];
    
    //this for password eye icon   //not completed  ...pendfing
  //  [self.passcodeTextField addPasswordField];
    
    _servicdeskUrlLabel.textColor = [UIColor colorFromHexString:@"049BE5"];
    _urlNextButton.backgroundColor = [UIColor colorFromHexString:@"1287DE"];
    
    
    
//    _loginLabel.userInteractionEnabled=YES;
//
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginClicked)];
//
//    [_loginLabel addGestureRecognizer:tap];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [self.urlTextfield becomeFirstResponder];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES];
    
    [utils viewSlideInFromRightToLeft:self.companyURLview];
    
    [self.loginView setHidden:YES];
    [self.companyURLview setHidden:NO];
    
}

-(void)textFieldFinished:(id)sender
{
    [_urlTextfield resignFirstResponder];
    [_userNameTextField resignFirstResponder];
    [_passcodeTextField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField == _urlTextfield)
    {
        NSLog(@"Clicked on go");
        [SVProgressHUD showWithStatus:@"Verifying URL"];
        [self performSelector:@selector(URLValidationMethod) withObject:self afterDelay:2.0];
       
       
    }
    
    return YES;
}


- (IBAction)urlNextButtonAction:(id)sender {
    
    [self.urlTextfield resignFirstResponder];
    [SVProgressHUD showWithStatus:@"Verifying URL"];
    [self performSelector:@selector(URLValidationMethod) withObject:self afterDelay:2.0];
   
}


-(void)URLValidationMethod
{

    
    if (self.urlTextfield.text.length==0){
        
        [utils showAlertWithMessage:@"Please Enter the URL" sendViewController:self];
        [SVProgressHUD dismiss];
        
    }
    else{
        if ([Utils validateUrl:self.urlTextfield.text]) {
            
            baseURL=[[NSString alloc] init];
            
            if ([self.urlTextfield.text hasSuffix:@"/"]) {
                baseURL=self.urlTextfield.text;
            }else{
                baseURL=[self.urlTextfield.text stringByAppendingString:@"/"];
            }
            
            if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
            {
                [SVProgressHUD dismiss];
            
                
                if (self.navigationController.navigationBarHidden) {
                    [self.navigationController setNavigationBarHidden:NO];
                }
                
                [RMessage showNotificationInViewController:self.navigationController
                                                     title:NSLocalizedString(@"Something failed", nil)
                                                  subtitle:NSLocalizedString(@"The internet connection seems to be down. Please check it.", nil)
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
                //show loader
                
                NSString *url=[NSString stringWithFormat:@"%@api/v1/helpdesk/url?url=%@&api_key=%@",baseURL,[baseURL substringToIndex:[baseURL length]-1],API_KEY];
                NSLog(@"Check URL is :%@",url);
                
                globalVariables.urlDemo=baseURL;
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request addValue:@"application/json" forHTTPHeaderField:@"Offer-type"];
                [request setTimeoutInterval:45.0];
                [request setURL:[NSURL URLWithString:url]];  // add your url
                [request setHTTPMethod:@"GET"];  // specify the JSON type to GET
                
                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] ];
                // intialiaze NSURLSession
                
                
                [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    // Add your parameters in blocks
                    
                    // handle basic connectivity issues here
                    
                    if ([[error domain] isEqualToString:NSURLErrorDomain]) {
                        switch ([error code]) {
                            case NSURLErrorCannotFindHost:
                                self->errorMsg = NSLocalizedString(@"Cannot find specified host. Retype URL.", nil);
                                break;
                            case NSURLErrorCannotConnectToHost:
                                self->errorMsg = NSLocalizedString(@"Cannot connect to specified host. Server may be down.", nil);
                                break;
                            case NSURLErrorNotConnectedToInternet:
                                self->errorMsg = NSLocalizedString(@"Cannot connect to the internet. Service may not be available.", nil);
                                break;
                            default:
                                self->errorMsg = [error localizedDescription];
                                break;
                        }
                        
                        [SVProgressHUD dismiss];
                        
                        [self->utils showAlertWithMessage:self->errorMsg sendViewController:self];
                        
                        NSLog(@"dataTaskWithRequest error: %@", self->errorMsg);
                        return;
                    }
                    else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        
                        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                        
                        if (statusCode != 200) {
                            if (statusCode == 404) {
                                NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                //  [[AppDelegate sharedAppdelegate] hideProgressView];
                                [SVProgressHUD dismiss];
                                [self->utils showAlertWithMessage:@"The requested URL was not found on this server." sendViewController:self];
                                return;
                            }
                            else if(statusCode == 400)
                            {
                                NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                
                                [self->utils showAlertWithMessage:@"API is disabled in web, please enable it from Admin panel." sendViewController:self];
                                //  [[AppDelegate sharedAppdelegate] hideProgressView];
                                [SVProgressHUD dismiss];
                            }
                            else if (statusCode == 401 || statusCode == 400) {
                                NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                // [[AppDelegate sharedAppdelegate] hideProgressView];
                                   [SVProgressHUD dismiss];
                                [self->utils showAlertWithMessage: NSLocalizedString(@"API is disabled in web, please enable it from Admin panel.", nil) sendViewController:self];
                                //[utils showAlertWithMessage:@"Wrong Username or Password" sendViewController:self];
                                return;
                            }
                            else if (statusCode == 500) {
                                NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                //   [[AppDelegate sharedAppdelegate] hideProgressView];
                                     [SVProgressHUD dismiss];
                                [self->utils showAlertWithMessage: NSLocalizedString(@"Internal Server Error. Something has gone wrong on the website's server", nil) sendViewController:self];
                                //[utils showAlertWithMessage:@"Wrong Username or Password" sendViewController:self];
                                return;
                            }
                            else{
                                NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                //   [[AppDelegate sharedAppdelegate] hideProgressView];
                                     [SVProgressHUD dismiss];
                                [self->utils showAlertWithMessage:@"Unknown Error!" sendViewController:self];
                                return;
                            }
                        }
                    }
                    
                    NSString *replyStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"Get your response == %@", replyStr);
                    
                    @try{  //result
                        if ([replyStr containsString:@"message"]) {
                            
                            NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                            
                            NSString *msg = [jsonData objectForKey:@"message"];
                            if([msg isEqualToString:@"API disabled"])
                            {
                                [self->utils showAlertWithMessage:@"API is disabled in web, please enable it from Admin panel." sendViewController:self];
                                //  [[AppDelegate sharedAppdelegate] hideProgressView];
                                    [SVProgressHUD dismiss];
                                
                            }
                            
                        }else if ([replyStr containsString:@"result"]) {
                            
                            NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                            
                            NSString *msg = [jsonData objectForKey:@"result"];
                            
                            if([msg isEqualToString:@"success"])
                            {
                                NSLog(@"Success");
                                
                                [self verifyBilling];
                                
                            }
                            
                        }else{
                            
                            //  [[AppDelegate sharedAppdelegate] hideProgressView];
                                [SVProgressHUD dismiss];
                            
                            [self->utils showAlertWithMessage:NSLocalizedString(@"Error - Please Check Your Helpdesk URL",nil)sendViewController:self];
                        }
                    }@catch (NSException *exception)
                    {
                        NSLog( @"Name: %@", exception.name);
                        NSLog( @"Reason: %@", exception.reason );
                        [self->utils showAlertWithMessage:exception.name sendViewController:self];
                        [SVProgressHUD dismiss];
                        
                        return;
                    }
                    @finally
                    {
                        NSLog( @" I am in Validate URL method in Login ViewController" );
                        
                    }
                    
                    NSLog(@"Got response %@ with error %@.\n", response, error);
                    // [[AppDelegate sharedAppdelegate] hideProgressView];
                    //   [SVProgressHUD dismiss];
                }]resume];
            }
            
        }else
            [utils showAlertWithMessage:NSLocalizedString(@"Please Enter a valid URL",nil) sendViewController:self];
    }

}
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [self.companyURLview setHidden:YES];
//        [self.loginView setHidden:NO];
//        [self->utils viewSlideInFromRightToLeft:self.loginView];
//       // [[AppDelegate sharedAppdelegate] hideProgressView];
//
//    });

//It will verify the URL either paid or not
-(void)verifyBilling{
    
    NSString *url=[NSString stringWithFormat:@"%@?url=%@",BILLING_API,baseURL];
    NSLog(@"url at VeryfuBillingIS : %@",url);
    
    @try{
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        
        [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg){
            
            if (error || [msg containsString:@"Error"]) {
                
              //  [[AppDelegate sharedAppdelegate] hideProgressView];
                  [SVProgressHUD dismiss];
                
                if (msg) {
                    if([msg isEqualToString:@"Error-402"])
                    {
                        NSLog(@"Message is : %@",msg);
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access denied - Either your role has been changed or your login credential has been changed."] sendViewController:self];
                    }
                    
                    else{
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                        NSLog(@"Thread-verifyBilling-error == %@",error.localizedDescription);
                    }
                    
                }else if(error)  {
                    [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                    NSLog(@"Thread-verifyBilling-error == %@",error.localizedDescription);
                }
                return ;
            }
            
            if (json) {
                NSLog(@"Thread-sendAPNS-token-json-%@",json);
                
                NSString * resultMsg= [json objectForKey:@"result"];
                
                if([resultMsg isEqualToString:@"fails"])
                {
                    [self->utils showAlertWithMessage:@"Your HELPDESK URL is not verified. This URL is not found in FAVEO HELPDESK BILLING." sendViewController:self];
                    
                  //  [[AppDelegate sharedAppdelegate] hideProgressView];
                      [SVProgressHUD dismiss];
                }
                else if([resultMsg isEqualToString:@"success"])
                {
                    
                    NSLog(@"Billing successful!");
                    dispatch_async(dispatch_get_main_queue(), ^{
                      
                      
                        
//                        [RMessage showNotificationWithTitle:NSLocalizedString(@"Success", nil)
//                                                   subtitle:NSLocalizedString(@"URL Verified successfully !", nil)
//                                                       type:RMessageTypeSuccess
//                                             customTypeName:nil
//                                                   callback:nil];
                        
                        if (self.navigationController.navigationBarHidden) {
                            [self.navigationController setNavigationBarHidden:NO];
                        }
                        
                        [RMessage showNotificationInViewController:self.navigationController
                                                             title:NSLocalizedString(@"Success", nil)
                                                          subtitle:NSLocalizedString(@"URL Verified successfully !", nil)
                                                         iconImage:nil
                                                              type:RMessageTypeSuccess
                                                    customTypeName:nil
                                                          duration:RMessageDurationAutomatic
                                                          callback:nil
                                                       buttonTitle:nil
                                                    buttonCallback:nil
                                                        atPosition:RMessagePositionNavBarOverlay
                                              canBeDismissedByUser:YES];
                        
                        
                        [self.companyURLview setHidden:YES];
                        [self.loginView setHidden:NO];
                        [[self navigationController] setNavigationBarHidden:YES];
                        [self->utils viewSlideInFromRightToLeft:self.loginView];
                    //    [[AppDelegate sharedAppdelegate] hideProgressView];
                        [SVProgressHUD dismiss];
                       
                        
                    });
                    [self->userdefaults setObject:[self->baseURL stringByAppendingString:@"api/v1/"] forKey:@"companyURL"];
                    [self->userdefaults synchronize];
                    
                }else{
                    
                    [self->utils showAlertWithMessage:@"Something went wrong in Billing. Please try later." sendViewController:self];
                    
               //     [[AppDelegate sharedAppdelegate] hideProgressView];
                      [SVProgressHUD dismiss];
                }
                
            }
            
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
        NSLog( @" I am in Verify Billing method in Login ViewController" );
        
    }
}


- (IBAction)logginButtonClicked:(id)sender {
    
    if (((self.userNameTextField.text.length==0 || self.passcodeTextField.text.length==0)))
    {
        if (self.userNameTextField.text.length==0 && self.passcodeTextField.text.length==0){
            [utils showAlertWithMessage:  NSLocalizedString(@"Please insert username & password", nil) sendViewController:self];
        }else if(self.userNameTextField.text.length==0 && self.passcodeTextField.text.length!=0)
        {
            [utils showAlertWithMessage:NSLocalizedString(@"Please insert username", nil) sendViewController:self];
        }else if(self.userNameTextField.text.length!=0 && self.passcodeTextField.text.length==0)
        {
            [utils showAlertWithMessage: NSLocalizedString(@"Please insert password", nil)sendViewController:self];
        }
    }
    else {
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
        {
            
            //            [RMessage
            //             showNotificationWithTitle:NSLocalizedString(@"Something failed", nil)
            //             subtitle:NSLocalizedString(@"The internet connection seems to be down. Please check it!", nil)
            //             type:RMessageTypeError
            //             customTypeName:nil
            //             callback:nil];
            
            if (self.navigationController.navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:NO];
            }
            
            [RMessage showNotificationInViewController:self.navigationController
                                                 title:NSLocalizedString(@"Something failed", nil)
                                              subtitle:NSLocalizedString(@"The internet connection seems to be down. Please check it.", nil)
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
            
            //  [[AppDelegate sharedAppdelegate] showProgressView];
            [SVProgressHUD showWithStatus:@"Please wait"];
            
            NSString *url=[NSString stringWithFormat:@"%@authenticate",[[NSUserDefaults standardUserDefaults] objectForKey:@"companyURL"]];
            // NSString *params=[NSString string];
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:self.userNameTextField.text,@"username",self.passcodeTextField.text,@"password",API_KEY,@"api_key",IP,@"ip",nil];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            [request setURL:[NSURL URLWithString:url]];
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setTimeoutInterval:60];
            
            [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:param options:kNilOptions error:nil]];
            [request setHTTPMethod:@"POST"];
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] ];
            
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"dataTaskWithRequest error: %@", error);
                    return;
                }else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    
                    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                    NSLog(@"Status code in Login : %ld",(long)statusCode);
                    NSLog(@"Status code in Login : %ld",(long)statusCode);
                    
                    if (statusCode != 200) {
                        
                        
                        if(statusCode == 404)
                        {
                            NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                            //    [[AppDelegate sharedAppdelegate] hideProgressView];
                            [SVProgressHUD dismiss];
                            [self->utils showAlertWithMessage:@"The requested URL was not found on this server." sendViewController:self];
                        }
                        
                        else if(statusCode == 405)
                        {
                            NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                            //    [[AppDelegate sharedAppdelegate] hideProgressView];
                            [SVProgressHUD dismiss];
                            [self->utils showAlertWithMessage:@"The request method is known by the server but has been disabled and cannot be used." sendViewController:self];
                        }
                        else if(statusCode == 500)
                        {
                            NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                            //    [[AppDelegate sharedAppdelegate] hideProgressView];
                            [SVProgressHUD dismiss];
                            [self->utils showAlertWithMessage:@"Internal Server Error. Something has gone wrong on the website's server." sendViewController:self];
                        }
                        
                    }
                    
                }
                
                NSString *replyStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSLog(@"Login Response is : %@",replyStr);
                
                NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"JSON is : %@",jsonData);
                
                //main if 1
                if ([replyStr containsString:@"success"] && [replyStr containsString:@"message"] ) {
                    
                    
                    NSString *msg=[jsonData objectForKey:@"message"];
                    
                    if([msg isEqualToString:@"Invalid credentials"])
                    {
                        [self->utils showAlertWithMessage:@"Invalid Credentials.Enter valid username or password" sendViewController:self];
                        // [[AppDelegate sharedAppdelegate] hideProgressView];
                        [SVProgressHUD dismiss];
                    }
                    else if([msg isEqualToString:@"API disabled"])
                    {
                        [self->utils showAlertWithMessage:@"API is disabled in web, please enable it from Admin panel." sendViewController:self];
                        //  [[AppDelegate sharedAppdelegate] hideProgressView];
                        [SVProgressHUD dismiss];
                    }
                    
                }
                
                else         //success = true
                    if ([replyStr containsString:@"success"] && [replyStr containsString:@"data"] ) {
                        {
                            
                            NSDictionary *userDataDict=[jsonData objectForKey:@"data"];
                            NSString *tokenString=[NSString stringWithFormat:@"%@",[userDataDict objectForKey:@"token"]];
                            NSLog(@"Token is : %@",tokenString);
                            
                            [self->userdefaults setObject:[userDataDict objectForKey:@"token"] forKey:@"token"];
                            
                            NSDictionary *userDetailsDict=[userDataDict objectForKey:@"user"];
                            
                            NSString * userId=[NSString stringWithFormat:@"%@",[userDetailsDict objectForKey:@"id"]];
                            
                            NSString * firstName=[NSString stringWithFormat:@"%@",[userDetailsDict objectForKey:@"first_name"]];
                            
                            NSString * lastName=[NSString stringWithFormat:@"%@",[userDetailsDict objectForKey:@"last_name"]];
                            
                            NSString * userName=[NSString stringWithFormat:@"%@",[userDetailsDict objectForKey:@"user_name"]];
                            
                            NSString * userProfilePic=[NSString stringWithFormat:@"%@",[userDetailsDict objectForKey:@"profile_pic"]];
                            
                            NSString * userRole=[NSString stringWithFormat:@"%@",[userDetailsDict objectForKey:@"role"]];
                            
                            NSString * userEmail = [NSString stringWithFormat:@"%@",[userDetailsDict objectForKey:@"email"]];
                            [self->userdefaults setObject:userEmail forKey:@"userEmail"];
                            
                            
                            
                            [self->userdefaults setObject:userId forKey:@"user_id"];
                            [self->userdefaults setObject:userProfilePic forKey:@"profile_pic"];
                            [self->userdefaults setObject:userRole forKey:@"role"];
                            
                            NSString *profileName;
                            if ([userName isEqualToString:@""]) {
                                profileName=userName;
                            }else{
                                profileName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                            }
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self->userdefaults setObject:profileName forKey:@"profile_name"];
                                [self->userdefaults setObject:self->baseURL forKey:@"baseURL"];
                                [self->userdefaults setObject:self.userNameTextField.text forKey:@"username"];
                                
                                [self->userdefaults setObject:self.passcodeTextField.text forKey:@"password"];
                                [self->userdefaults setBool:YES forKey:@"loginSuccess"];
                                [self->userdefaults synchronize];
                                
                            });
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if([userRole isEqualToString:@"admin"] || [userRole isEqualToString:@"agent"]){
                                    
                                    
                                    
                                    
                                    [self sendDeviceToken];
                                    
                                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                    
                                    InboxTickets *inboxVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"inboxId"];
                                    
                                    SampleNavigation *navigation = [[SampleNavigation alloc] initWithRootViewController:inboxVC];
                                    
                                    ExpandableTableViewController *sidemenu = (ExpandableTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"sideMenu"];
                                    
                                    SWRevealViewController * vc= [[SWRevealViewController alloc]initWithRearViewController:sidemenu frontViewController:navigation];
                                    
                                    [self presentViewController:vc animated:YES completion:nil];
                                    
                                    // [self.navigationController pushViewController:inboxVC animated:YES];
                                    
                                    if (self.navigationController.navigationBarHidden) {
                                        [self.navigationController setNavigationBarHidden:NO];
                                    }
                                    
                                    [RMessage showNotificationInViewController:self.navigationController
                                                                         title:NSLocalizedString(@"Welcome.",nil)
                                                                      subtitle:NSLocalizedString(@"You have logged in successfully.",nil)
                                                                     iconImage:nil
                                                                          type:RMessageTypeSuccess
                                                                customTypeName:nil
                                                                      duration:RMessageDurationAutomatic
                                                                      callback:nil
                                                                   buttonTitle:nil
                                                                buttonCallback:nil
                                                                    atPosition:RMessagePositionNavBarOverlay
                                                          canBeDismissedByUser:YES];
                                    
                                    
                                }else
                                {
                                    [self->utils showAlertWithMessage:@"Invalid entry for user. This app is used by Agent and Admin only." sendViewController:self];
                                    // [[AppDelegate sharedAppdelegate] hideProgressView];
                                    [SVProgressHUD dismiss];
                                    
                                    
                                    
                                }
                            });
                            
                            
                        }   //end sucess=true if  here
                        
                        
                    }else
                    {
                        
                        
                        [self->utils showAlertWithMessage:@"Whoops! Something went Wrong! Please try again." sendViewController:self];
                        // [[AppDelegate sharedAppdelegate] hideProgressView];
                        [SVProgressHUD dismiss];
                        
                    }
                
                
            }] resume];
            
        }
        
    }
    
    
    
}





- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//it will send an token to Firebase with user details (Logged user)
-(void)sendDeviceToken{
    NSString *refreshedToken =  [[FIRInstanceID instanceID] token];
    NSLog(@"refreshed token  %@",refreshedToken);
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *url=[NSString stringWithFormat:@"%@fcmtoken?user_id=%@&fcm_token=%@&os=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"user_id"],[[FIRInstanceID instanceID] token],@"ios"];
    
    NSLog(@"URL is %@",url);
    NSLog(@"URL is %@",url);
    
   

    @try{
        MyWebservices *webservices=[MyWebservices sharedInstance];
        [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg){
            if (error || [msg containsString:@"Error"]) {
                if (msg) {


                    NSLog(@"Thread-postAPNS-toserver-error == %@",error.localizedDescription);
                }else if(error)  {
                    //
                    NSLog(@"Thread-postAPNS-toserver-error == %@",error.localizedDescription);
                }
                return ;
            }
            if (json) {

                NSLog(@"Thread-sendAPNS-token-json-%@",json);
            }

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
        NSLog( @" I am in sendDeviceToken method in Login ViewController" );

    }
}



@end
