//
//  ReplyTicketViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 09/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ReplyTicketViewController.h"
#import "Utils.h"
#import "GlobalVariables.h"
#import "MyWebservices.h"
#import "AppConstanst.h"
#import "UIColor+HexColors.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "RMessage.h"
#import "RMessageView.h"

@interface ReplyTicketViewController ()<RMessageProtocol,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    NSMutableArray *usersArray;
    
    NSArray  * ccListArray;
    
    // HSAttachmentPicker *_menu;
    
    NSData *attachNSData;
    NSString *file123;
    NSString *base64Encoded;
    NSString *typeMime;
    
}
@end

@implementation ReplyTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Reply Ticket";
    
    self.tableview.separatorColor=[UIColor clearColor];
    
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    utils=[[Utils alloc]init];
    
    
    UIButton *attachmentButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [attachmentButton setImage:[UIImage imageNamed:@"attach1"] forState:UIControlStateNormal];
    [attachmentButton addTarget:self action:@selector(addAttachmentPickerButton) forControlEvents:UIControlEventTouchUpInside];
    [attachmentButton setFrame:CGRectMake(12, 7, 22, 22)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    // [rightBarButtonItems addSubview:addBtn];
    [rightBarButtonItems addSubview:attachmentButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    
    //giving action to lables
    _addCCLabel.userInteractionEnabled=YES;
    _viewCCLabel.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedOnCCSubButton)];
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewCCorRemoceCCButton)];
    
    _addCCLabel.userInteractionEnabled=YES;
    _viewCCLabel.userInteractionEnabled=YES;
    
    [_addCCLabel addGestureRecognizer:tapGesture];
    [_viewCCLabel addGestureRecognizer:tapGesture2];
    
    
    if(globalVariables.ccCount==0)
    {
        _viewCCLabel.text=@"View cc";
    }else
    {
        _viewCCLabel.text=[NSString stringWithFormat:@"View cc (%@ Recipients)",globalVariables.ccCount];
    }
    
    _addCCLabel.textColor= [UIColor colorFromHexString:@"00AEEF"];
    _viewCCLabel.textColor= [UIColor colorFromHexString:@"00AEEF"];
    _msgLabel.textColor= [UIColor colorFromHexString:@"00AEEF"];
    
    
    UIToolbar *toolBar= [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *removeBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain  target:self action:@selector(removeKeyBoard)];
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:space,removeBtn, nil]];
    [self.messageTextView setInputAccessoryView:toolBar];
    
    _submitButtonOutlet.backgroundColor= [UIColor colorFromHexString:@"00AEEF"];

    
}

-(void)removeKeyBoard
{
    
    [_messageTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//This method is called before the view controller's view is about to be added to a view hierarchy and before any animations are configured for showing the view.
-(void)viewWillAppear:(BOOL)animated
{
    [self viewDidLoad];
    [self FetchCollaboratorAssociatedwithTicket];
    
    
}

// After clcking this method, it will move to add cc view controller
-(void)clickedOnCCSubButton
{
    
//    addCCView *cc1=[self.storyboard instantiateViewControllerWithIdentifier:@"addCCViewId"];
//    [self.navigationController pushViewController:cc1 animated:YES];
    
}

-(void)viewCCorRemoceCCButton
{
    
    NSLog(@"Clicked");
    
    if ([ccListArray count] > 0) {
        globalVariables.ccListArray1=ccListArray;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ViewCCList *smallViewController = [storyboard instantiateViewControllerWithIdentifier:@"ccListID"];
//
//        BIZPopupViewController *popupViewController = [[BIZPopupViewController alloc] initWithContentViewController:smallViewController contentSize:CGSizeMake(300, 300)];
 //      [self presentViewController:popupViewController animated:NO completion:nil];
    }
    else{
        
        [utils showAlertWithMessage:@"There is no cc available." sendViewController:self];
    }
    
}



- (IBAction)submitButtonAction:(id)sender {
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    if([_messageTextView.text isEqualToString:@""] || [_messageTextView.text length]==0)
    {
        [utils showAlertWithMessage:@"Enter the reply content.It can not be empty." sendViewController:self];
        [SVProgressHUD dismiss];;
        
    }else
    {
        //  [self replyTicketMethodCall];
        
        [self performSelector:@selector(replyTicketMethodCall) withObject:self afterDelay:5.0];
    }
    
}

// This method fetch the cc list
-(void)FetchCollaboratorAssociatedwithTicket
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //[RKDropdownAlert title:APP_NAME message:NO_INTERNET backgroundColor:[UIColor hx_colorWithHexRGBAString:FAILURE_COLOR] textColor:[UIColor whiteColor]];
        
    }else{
        
        NSString *url =[NSString stringWithFormat:@"%@helpdesk/collaborator/get-ticket?token=%@&ticket_id=%@&user_id=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"token"],globalVariables.ticketId,globalVariables.userIdFromTicket];
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        
        [SVProgressHUD dismiss];

        
        [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
         //   [[AppDelegate sharedAppdelegate] hideProgressView];
            
            
            if (error || [msg containsString:@"Error"]) {
                
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
                        else  if([msg isEqualToString:@"Error-402"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access denied - Either your role has been changed or your login credential has been changed."] sendViewController:self];
                        }
                        else if([msg isEqualToString:@"Error-422"]){
                            
                            NSLog(@"Message is : %@",msg);
                        }else{
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                            NSLog(@"Error is11 : %@",msg);
                        }
                    
                }else if(error)  {
                    [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                    NSLog(@"Thread-NO4-CollaboratorFetch-Refresh-error == %@",error.localizedDescription);
                }
                
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                [self FetchCollaboratorAssociatedwithTicket];
                NSLog(@"Thread--NO4-call-CollaboratorFetch");
                return;
            }
            
            if (json) {
                NSLog(@"JSON-CollaboratorWithTicket-%@",json);
                //  NSDictionary * dict1=[json objectForKey:@"collaborator"];
                
                self->ccListArray=[json objectForKey:@"collaborator"];
                
                self->globalVariables.ccCount=[NSString stringWithFormat:@"%lu",(unsigned long)self->ccListArray.count];//array1.count;
                //NSLog(@"Array count is : %lu",(unsigned long)array1.count);
                NSLog(@"Array count is : %@",self->globalVariables.ccCount);
                [self viewDidLoad];
            }
            
        }];
    }
    
}

//Asks the delegate whether the specified text should be replaced in the text view.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if(textView == _messageTextView)
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
        
        if([textView.text stringByReplacingCharactersInRange:range withString:text].length >500)
        {
            return NO;
        }
        
        NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890,.1234567890!@#$^&*()--=+/?:;{}[]| "];
        
        
        if([text rangeOfCharacterFromSet:set].location == NSNotFound)
        {
            return NO;
        }
    }
    
    
    return YES;
}

// Here attachment picker will initialize
//-(void)addAttachmentPickerButton
//{
//    _menu = [[HSAttachmentPicker alloc] init];
//    _menu.delegate = self;
//    [_menu showAttachmentMenu];
//
//}





// It calls the ticket reply api
-(void)replyTicketMethodCall
{
    
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
            
            NSString *urlString=[NSString stringWithFormat:@"%@helpdesk/reply?token=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"token"]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSMutableData *body = [NSMutableData data];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            // attachment parameter
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media_attachment[]\"; filename=\"%@\"\r\n", file123] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", typeMime] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:attachNSData]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            // reply content parameter
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"reply_content\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[_messageTextView.text dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            NSString * tickerId=[NSString stringWithFormat:@"%@",globalVariables.ticketId];
            // ticket id parameter
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ticket_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[tickerId dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // set request body
            [request setHTTPBody:body];
            
            NSLog(@"Request is : %@",request);
            
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
            // "message": "Successfully replied"
            
            
            
            if ([jsonData objectForKey:@"message"]){
                
                NSString * msg=[jsonData objectForKey:@"message"];
                
                
                if([msg isEqualToString:@"Successfully replied"])
                {
                    
                    [SVProgressHUD dismiss];
                    
                    if (self.navigationController.navigationBarHidden) {
                        [self.navigationController setNavigationBarHidden:NO];
                    }
                    
                    [RMessage showNotificationInViewController:self.navigationController
                                                         title:NSLocalizedString(@"success.",nil)
                                                      subtitle:NSLocalizedString(@"Posted your reply.",nil)
                                                     iconImage:nil
                                                          type:RMessageTypeSuccess
                                                customTypeName:nil
                                                      duration:RMessageDurationAutomatic
                                                      callback:nil
                                                   buttonTitle:nil
                                                buttonCallback:nil
                                                    atPosition:RMessagePositionNavBarOverlay
                                          canBeDismissedByUser:YES];
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
                    
                    [self.view setNeedsDisplay];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
                else if ([jsonData objectForKey:@"message"])
                {
                    
                    NSString *str=[jsonData objectForKey:@"message"];
                    
                    if([str isEqualToString:@"Token expired"])
                    {
                        MyWebservices *web=[[MyWebservices alloc]init];
                        [web refreshToken];
                        [self replyTicketMethodCall];
                        
                    }
                }
                else
                {
                    [self->utils showAlertWithMessage:@"Something went wrong. Please try again." sendViewController:self];
                    [SVProgressHUD dismiss];
                }
                NSLog(@"Thread-Ticket-Reply-closed");
                
            }
            if ([jsonData objectForKey:@"result"]){
                
                NSDictionary *resultDict=[jsonData objectForKey:@"result"];
                
                if([[resultDict objectForKey:@"fails"] isEqualToString:@"Access denied"])
                {
                    [self->utils showAlertWithMessage:@"Access Denied - You role or login credentials has been changed." sendViewController:self];
                    [SVProgressHUD dismiss];
                }
                
            }
            
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
            NSLog( @" I am in replytTicket method in TicketDetail ViewController" );
            
        }
        
    }
}



@end
