//
//  TicketMergeView.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 29/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "TicketMergeView.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "Reachability.h"
#import "MyWebservices.h"
#import "IQKeyboardManager.h"
#import "Utils.h"
#import "UIColor+HexColors.h"
#import "AppConstanst.h"
#import "InboxTickets.h"
#import "GlobalVariables.h"
#import "ActionSheetStringPicker.h"
#import "SVProgressHUD.h"
#import "InboxTickets.h"


@interface TicketMergeView () <RMessageProtocol>
{
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    NSNumber *subject_id;
    NSMutableArray * subject_idArray;
    NSString *filteredID;
    NSString *concatnateNewString;
}

@property (nonatomic, strong) NSMutableArray * SubjectArray1;
- (void)SubjectWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)actionPickerCancelled:(id)sender;


@end

@implementation TicketMergeView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title=NSLocalizedString(@"Merge Tickets",nil);
    self.tableView.separatorColor = [UIColor clearColor];
    
    subject_id =[[NSNumber alloc]init];
    subject_idArray=[[NSMutableArray alloc]init];
    
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    UIToolbar *toolBar= [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *removeBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain  target:self action:@selector(removeKeyBoard)];
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:space,removeBtn, nil]];
    [self.newtitleTextview setInputAccessoryView:toolBar];
    [self.reasonTextView setInputAccessoryView:toolBar];
    // [self.parentTicketTextField setInputAccessoryView:toolBar];
    
    //giving action to label
    _cancelLabel.userInteractionEnabled=YES;
    _mergeLabel.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButton)];
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mergeButton)];
    
    [_cancelLabel addGestureRecognizer:tap];
    [_mergeLabel addGestureRecognizer:tap2];
    
    _cancelLabel.backgroundColor=[UIColor colorFromHexString:@"00aeef"];
    _mergeLabel.backgroundColor=[UIColor colorFromHexString:@"00aeef"];
    
    
   
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style: UIBarButtonItemStylePlain target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // to set black background color mask for Progress view
      [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SelectParentTicket:(id)sender {
    
     [self.view endEditing:YES];
    
    [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Parent Ticket",nil) rows:globalVariables.subjectList initialSelection:0 target:self successAction:@selector(SubjectWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    
}

// This is action called when picker view cancelled
- (void)actionPickerCancelled:(id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

//This method used to select the subejct
- (void)SubjectWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    subject_id=(globalVariables.idList)[(NSUInteger) [selectedIndex intValue]];
    self.parentTicketTextField.text = (globalVariables.subjectList)[(NSUInteger) [selectedIndex intValue]];
    
    NSLog(@"List of id is :%@",globalVariables.idList);
    NSLog(@"Subject_id issss :%@",subject_id);
    NSLog(@"Selectd value in textfiled is : %@",_parentTicketTextField.text);
    
    
    
}

// Added naviagtion button on left side of view.
-(void)Back
{
    globalVariables.backButtonActionFromMergeViewMenu=@"true";
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)removeKeyBoard{
    [_newtitleTextview resignFirstResponder];
    [_reasonTextView resignFirstResponder];
}

// After clicking this cancel button, it will redirect back to inbox page.
-(void)cancelButton
{
    NSLog(@"Ckicked on cancel button");
    InboxTickets *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"inboxId"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

// This is the main method, after selecting all values which are required to merge the tickets. AFter clicking on merge button, it will call an merge API and gives an JSON.
-(void)mergeButton
{
    [SVProgressHUD showWithStatus:@"Merging Tickets"];
    NSLog(@"Ckicked on merge button");
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        
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
        
        
    }else if([_parentTicketTextField.text length] == 0 || [_parentTicketTextField.text isEqualToString:@""])
    {
        
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO];
        }
        
        [RMessage showNotificationInViewController:self.navigationController
                                             title:NSLocalizedString(@"Warning !", nil)
                                          subtitle:NSLocalizedString(@"Please Select The Parent Ticket.", nil)
                                         iconImage:nil
                                              type:RMessageTypeWarning
                                    customTypeName:nil
                                          duration:RMessageDurationAutomatic
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionNavBarOverlay
                              canBeDismissedByUser:YES];
        
       [SVProgressHUD dismiss];
        
    }else  {
        
        // reomving parenmt id from array
        for(id item in globalVariables.idList) {
            if([item isEqual:subject_id]) {
                [globalVariables.idList removeObject:item];
                NSLog(@"New Array is: %@",globalVariables.idList);
                
                filteredID = [globalVariables.idList componentsJoinedByString:@","];
                
                NSLog(@"New Array 111 is: %@",filteredID);
                
                break;
            }
        }
        
        
        //    NSString * str=@"[]=";
        
        //    filteredID= [str stringByAppendingString:filteredID];
        
        
        NSString *url= [NSString stringWithFormat:@"%@api/v2/helpdesk/merge?api_key=%@&token=%@&p_id=%@&t_id[]=%@&title=%@&reason=%@",[userDefaults objectForKey:@"baseURL"],API_KEY,[userDefaults objectForKey:@"token"],subject_id,filteredID,_newtitleTextview.text,_reasonTextView.text];
        
        NSLog(@"Url is : %@",url);
        
        
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
                        else
                            
                            if([msg isEqualToString:@"Error-403"])
                            {
                                [self->utils showAlertWithMessage:NSLocalizedString(@"Access Denied - You don't have permission.", nil) sendViewController:self];
                                
                            }
                            else if([msg isEqualToString:@"Error-402"])
                            {
                                [self->utils showAlertWithMessage:NSLocalizedString(@"Your account credentials were changed, contact to Admin and please log back in.", nil) sendViewController:self];
                               
                                
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
                        
                            else{
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                                NSLog(@"Error is : %@",msg);
                                
                            }
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-NO4-postMerge-Refresh-error == %@",error.localizedDescription);
                        [SVProgressHUD dismiss];
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self mergeButton];
                    NSLog(@"Thread--NO4-call-postMerge");
                    return;
                }
                
                
                if (json) {
                    NSLog(@"JSON-Merge-Function%@",json);
                    
                    NSDictionary *dict1= [json objectForKey:@"response"];
                    
                    NSObject * response1=[dict1 objectForKey:@"message"];
                    
                    //checking response is king of dictionary
                    if([response1 isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *dict1= [json objectForKey:@"response"];
                        
                        NSDictionary * dict2=[dict1 objectForKey:@"message"];
                        NSString *str=[dict2 objectForKey:@"message"];
                        
                        if([str isEqualToString:@"tickets from different users"])
                        {
                            [self->utils showAlertWithMessage:@"You can't merge these tickets because tickets from different users" sendViewController:self];
                            [SVProgressHUD dismiss];
                        }
                        else
                        {
                            [self->utils showAlertWithMessage:@"Something went wrong...!" sendViewController:self];
                           [SVProgressHUD dismiss];
                        }
                    }
                    else{
                        
                        NSDictionary *dict1= [json objectForKey:@"response"];
                        
                        NSString * response1=[dict1 objectForKey:@"message"];
                        NSString * msg=@"merged successfully";
                        
                       [SVProgressHUD dismiss];
                        if([response1 isEqualToString: msg])
                        {
                
                            [SVProgressHUD dismiss];
                            
                            if (self.navigationController.navigationBarHidden) {
                                [self.navigationController setNavigationBarHidden:NO];
                            }
                            
                            [RMessage showNotificationInViewController:self.navigationController
                                                                 title:NSLocalizedString(@"success.", nil)
                                                              subtitle:NSLocalizedString(@"Merged Successfully.", nil)
                                                             iconImage:nil
                                                                  type:RMessageTypeSuccess
                                                        customTypeName:nil
                                                              duration:RMessageDurationAutomatic
                                                              callback:nil
                                                           buttonTitle:nil
                                                        buttonCallback:nil
                                                            atPosition:RMessagePositionNavBarOverlay
                                                  canBeDismissedByUser:YES];
                            
                            InboxTickets *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"inboxId"];
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        }else
                        {
                            [self->utils showAlertWithMessage:@"Something went wrong...!" sendViewController:self];
                           [SVProgressHUD dismiss];
                        }
                        
                        
                        
                    }
                }
                NSLog(@"Thread-NO5-postMerge-closed");
               [SVProgressHUD dismiss];
                
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
            NSLog( @" I am in mergeButton method in MergeViewForm ViewController" );
            
        }
        
    }
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

// This method used to control on giving input values in textfield or textviews
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if(textView == _newtitleTextview ||textView == _reasonTextView )
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
        
        if([textView.text stringByReplacingCharactersInRange:range withString:text].length >100)
        {
            return NO;
        }
        
        NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890\".,?()+=*&^%$#@!<>}{[]| "];
        
        
        if([text rangeOfCharacterFromSet:set].location == NSNotFound)
        {
            return NO;
        }
    }
    
    
    return YES;
}




@end
