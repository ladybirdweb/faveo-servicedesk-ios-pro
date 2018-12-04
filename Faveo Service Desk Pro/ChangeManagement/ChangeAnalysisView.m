//
//  ChangeAnalysisView.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/12/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ChangeAnalysisView.h"
#import "Utils.h"
#import "MyWebservices.h"
#import "GlobalVariables.h"
#import "SVProgressHUD.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "Reachability.h"
#import "ProblemDetailView.h"
#import "UIColor+HexColors.h"
#import "HexColors.h"
#import "ChangeDetailView.h"


@interface ChangeAnalysisView ()
{
    Utils *utils;
    UIRefreshControl *refresh;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    ChangeDetailView *changeDetail;
    
}
@end

@implementation ChangeAnalysisView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    
    _reasonTextView.editable=NO;
    _impactTextView.editable=NO;
    _rolloutPlanTextView.editable=NO;
    _backoutPlanTextView.editable=NO;
    
    [SVProgressHUD showWithStatus:@"Loading data"];
    
    [self getChangeReasonDetails];
    [self getChangeImpactDetails];
    [self getChangeRollOutPlanDetails];
    [self getChangeBackoutPlanDetails];
   
}

-(void)getChangeReasonDetails{

    NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/get/updates/%@/sd_changes/reason?token=%@&",[userDefaults objectForKey:@"baseURL"],globalVariables.changeId,[userDefaults objectForKey:@"token"]];
    NSLog(@"URL is : %@",url);
    
    
    MyWebservices *webservices=[MyWebservices sharedInstance];
    [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
        
        
        if (error || [msg containsString:@"Error"]) {
            
            if (msg) {
                
                
                NSLog(@"Message is : %@",msg);
                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                [SVProgressHUD dismiss];
            }
            
            else if(error)  {
                NSLog(@"Error is : %@",error);
                
                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
        
                [SVProgressHUD dismiss];
            }
            return ;
        }
        
        
        if([msg isEqualToString:@"tokenRefreshed"]){
            
            [self getChangeReasonDetails];
            
            return;
        }
        
        if (json) {
            
            NSLog(@"JSON is : %@",json);
            
            if([json isKindOfClass:[NSDictionary class]]){
                
                if (json[@"data"]){
                    
                    self->globalVariables.reasonForChangeValue = [json objectForKey:@"data"];
                }else{
                    self->globalVariables.reasonForChangeValue=@"Details are not added.";
                }
                
            }
            else{
                
                self->globalVariables.reasonForChangeValue=@"Details are not added.";
            }
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self->_reasonTextView.text = [NSString stringWithFormat:@"%@",self->globalVariables.reasonForChangeValue];
                    
                    
                });
            });
            
        }
        
    }];
    
}

-(void)getChangeImpactDetails{
    
    NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/get/updates/%@/sd_changes/impact?token=%@&",[userDefaults objectForKey:@"baseURL"],globalVariables.changeId,[userDefaults objectForKey:@"token"]];
    NSLog(@"URL is : %@",url);
    
    
    MyWebservices *webservices=[MyWebservices sharedInstance];
    [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
        
        
        if (error || [msg containsString:@"Error"]) {
            
            if (msg) {
                
                
                NSLog(@"Message is : %@",msg);
                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                [SVProgressHUD dismiss];
            }
            
            else if(error)  {
                NSLog(@"Error is : %@",error);
                
                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                
                [SVProgressHUD dismiss];
            }
            return ;
        }
        
        
        if([msg isEqualToString:@"tokenRefreshed"]){
            
            [self getChangeImpactDetails];
            
            return;
        }
        
        if (json) {
            
            NSLog(@"JSON is : %@",json);
            
            if([json isKindOfClass:[NSDictionary class]]){
                
                if (json[@"data"]){
                    
                    self->globalVariables.impactValueForChange = [json objectForKey:@"data"];
                }else{
                    self->globalVariables.impactValueForChange=@"Details are not added.";
                }
                
            }
            else{
                
                self->globalVariables.impactValueForChange=@"Details are not added.";
            }
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self->_impactTextView.text = [NSString stringWithFormat:@"%@",self->globalVariables.impactValueForChange];
                    
                    
                });
            });
            
        }
        
    }];
}

-(void)getChangeRollOutPlanDetails{
    
    NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/get/updates/%@/sd_changes/rollout-plan?token=%@&",[userDefaults objectForKey:@"baseURL"],globalVariables.changeId,[userDefaults objectForKey:@"token"]];
    NSLog(@"URL is : %@",url);
    
    
    MyWebservices *webservices=[MyWebservices sharedInstance];
    [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
        
        
        if (error || [msg containsString:@"Error"]) {
            
            if (msg) {
                
                
                NSLog(@"Message is : %@",msg);
                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                [SVProgressHUD dismiss];
            }
            
            else if(error)  {
                NSLog(@"Error is : %@",error);
                
                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                
                [SVProgressHUD dismiss];
            }
            return ;
        }
        
        
        if([msg isEqualToString:@"tokenRefreshed"]){
            
            [self getChangeRollOutPlanDetails];
            
            return;
        }
        
        if (json) {
            
            NSLog(@"JSON is : %@",json);
            
            if([json isKindOfClass:[NSDictionary class]]){
                
                if (json[@"data"]){
                    
                    self->globalVariables.rollOutValueForChange = [json objectForKey:@"data"];
                }else{
                    self->globalVariables.rollOutValueForChange=@"Details are not added.";
                }
                
            }
            else{
                
                self->globalVariables.rollOutValueForChange=@"Details are not added.";
            }
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self->_rolloutPlanTextView.text = [NSString stringWithFormat:@"%@",self->globalVariables.rollOutValueForChange];
                    
                    
                });
            });
           
            
        }
        
    }];
}

-(void)getChangeBackoutPlanDetails{
    
    NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/get/updates/%@/sd_changes/backout-plan?token=%@&",[userDefaults objectForKey:@"baseURL"],globalVariables.changeId,[userDefaults objectForKey:@"token"]];
    NSLog(@"URL is : %@",url);
    
    
    MyWebservices *webservices=[MyWebservices sharedInstance];
    [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
        
        
        if (error || [msg containsString:@"Error"]) {
            
            if (msg) {
                
                
                NSLog(@"Message is : %@",msg);
                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                [SVProgressHUD dismiss];
            }
            
            else if(error)  {
                NSLog(@"Error is : %@",error);
                
                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                
                [SVProgressHUD dismiss];
            }
            return ;
        }
        
        
        if([msg isEqualToString:@"tokenRefreshed"]){
            
            [self getChangeBackoutPlanDetails];
            
            return;
        }
        
        if (json) {
            
            NSLog(@"JSON is : %@",json);
            [SVProgressHUD dismiss];
            
            if([json isKindOfClass:[NSDictionary class]]){
                
                if (json[@"data"]){
                    
                    self->globalVariables.backOutValueForChange = [json objectForKey:@"data"];
                }else{
                    self->globalVariables.backOutValueForChange=@"Details are not added.";
                }
                
            }
            else{
                
                self->globalVariables.backOutValueForChange=@"Details are not added.";
            }
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self->_backoutPlanTextView.text = [NSString stringWithFormat:@"%@",self->globalVariables.backOutValueForChange];
                    
                    
                });
            });
            
        }
        
    }];
}

@end
