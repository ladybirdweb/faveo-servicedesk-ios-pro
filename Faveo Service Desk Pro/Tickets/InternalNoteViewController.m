//
//  InternalNoteViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 09/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "InternalNoteViewController.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "AppConstanst.h"
#import "GlobalVariables.h"
#import "MyWebservices.h"
#import "Utils.h"
#import "UIColor+HexColors.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@interface InternalNoteViewController ()<RMessageProtocol,UITextFieldDelegate>
{
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    UIToolbar *toolBar;
    
    
}

@end

@implementation InternalNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    self.tableView.separatorColor=[UIColor clearColor];
    
    
    _submitButtonOutlet.backgroundColor= [UIColor colorFromHexString:@"00AEEF"];
    _noteContentLabel.textColor = [UIColor colorFromHexString:@"00AEEF"];
    
  
    //toolbar is uitoolbar object
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:space,btnDone, nil]];
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView setInputAccessoryView:toolBar];
    return YES;
}

-(IBAction)btnClickedDone:(id)sender
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// After clcking submit/add button this method is called, here it will check that content textvies is empty or not. It it is empty then then it will show error message else it will call add internal note api
- (IBAction)submitButtonAction:(id)sender {
    
    [SVProgressHUD showWithStatus:@"Adding note"];
    
    if([_noteTextView.text isEqualToString:@""] || [_noteTextView.text length]==0)
    {
        [utils showAlertWithMessage:@"The body field is required.It can not be empty." sendViewController:self];
        [SVProgressHUD dismiss];
    }else
    {
        [self addInternalNoteApiMethodCall];
    }
    
}


-(void)addInternalNoteApiMethodCall
{
    [_noteTextView resignFirstResponder];
    
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
        
        [SVProgressHUD dismiss];
        
    }else{
    
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/internal-note?api_key=%@&ip=%@&token=%@&user_id=%@&body=%@&ticket_id=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],[userDefaults objectForKey:@"user_id"],_noteTextView.text,globalVariables.ticketId];
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            
            [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                if (error || [msg containsString:@"Error"]) {
                   [SVProgressHUD dismiss];
                    
                    if (msg) {
                        if([msg isEqualToString:@"Error-401"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access Denied.  Your credentials has been changed. Contact to Admin and try to login again."] sendViewController:self];
                        }
                        else if([msg isEqualToString:@"Error-402"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access denied - Either your role has been changed or your login credential has been changed."] sendViewController:self];
                        }
                        else{
                            
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                           
                        }
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-InternalNote-Refresh-error == %@",error.localizedDescription);
                       
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self addInternalNoteApiMethodCall];
                    NSLog(@"Thread-InternalNote-RefreshCall");
                    return;
                }
                
                if (json) {
                    NSLog(@"JSON-InternalNote-%@",json);
                    
                    if ([json objectForKey:@"thread"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                            
                            if (self.navigationController.navigationBarHidden) {
                                [self.navigationController setNavigationBarHidden:NO];
                            }
                            
                            [RMessage showNotificationInViewController:self.navigationController
                                                                 title:NSLocalizedString(@"Success",nil)
                                                              subtitle:NSLocalizedString(@"Posted your note.",nil)
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
                            
                            
                        });
                    }
                    else if([json objectForKey:@"error"]) {
                        
                        [self->utils showAlertWithMessage:@"The body field is required.It can not be empty." sendViewController:self];
                        [SVProgressHUD dismiss];
                        
                    }
                    else
                    {
                        
                        [self->utils showAlertWithMessage:@"Something Went Wrong. Please try again later." sendViewController:self];
                       [SVProgressHUD dismiss];
                        
                    }
                }//end josn
                NSLog(@"Thread-InternalNote-closed");
                
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
            NSLog( @" I am in InternalNote API call method in AllNote ViewController" );
            
        }
        
        
    }
    
}



//This method asks the delegate whether the specified text should be replaced in the text view.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (range.length == 0) {
        if ([text isEqualToString:@"\n"]) {
            _noteTextView.text = [NSString stringWithFormat:@"%@\n\t",_noteTextView.text];
            return NO;
        }
    }
    
    
    if(textView == _noteTextView)
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


@end
