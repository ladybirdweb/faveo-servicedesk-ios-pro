//
//  AnalysisView.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "AnalysisView.h"
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
#import "ProblemDetailView.h"

@interface AnalysisView ()
{
    Utils *utils;
    UIRefreshControl *refresh;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    ProblemDetailView *probleDetail;
    
}
@end

@implementation AnalysisView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    
    _rootCauseTextView.editable=NO;
    _impactTextView.editable=NO;
    _symptomsTextView.editable=NO;
    _solutionTextView.editable=NO;
    
    [SVProgressHUD showWithStatus:@"Loading Details"];
    
     [self getRootCauseDetails];
     [self getImpactDetails];
     [self getSymptomsDetails];
     [self getSolutionDetails];
    
     //[self updateUI];
}

//-(void)updateUI{
//
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            self->_rootCauseTextView.text = [NSString stringWithFormat:@"%@",self->globalVariables.rootCuaseValue];
//
//
//        });
//    });
//
//}

-(void)getRootCauseDetails{
    
    NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/get/updates/%@/sd_problem/root-cause?token=%@&",[userDefaults objectForKey:@"baseURL"],globalVariables.problemId,[userDefaults objectForKey:@"token"]];
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
                //NSLog(@"Thread-error == %@",error.localizedDescription);
                [SVProgressHUD dismiss];
            }
            return ;
        }
        
        
        if([msg isEqualToString:@"tokenRefreshed"]){
            
            [self getRootCauseDetails];
            
            return;
        }
        
        if (json) {
            
            //   [SVProgressHUD dismiss];
            NSLog(@"JSON is : %@",json);
            
            if([json isKindOfClass:[NSDictionary class]]){
                
                if (json[@"data"]){
                    
                   self->globalVariables.rootCuaseValue = [json objectForKey:@"data"];
                }else{
                    self->globalVariables.rootCuaseValue=@"Details are not added.";
                }
                
            }
            else{
                
                self->globalVariables.rootCuaseValue=@"Details are not added.";
            }
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self->_rootCauseTextView.text = [NSString stringWithFormat:@"%@",self->globalVariables.rootCuaseValue];
                    
                    
                });
            });
            
        }
        
    }];
    
}

-(void)getImpactDetails{
    
    NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/get/updates/%@/sd_problem/impact?token=%@&",[userDefaults objectForKey:@"baseURL"],globalVariables.problemId,[userDefaults objectForKey:@"token"]];
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
                //NSLog(@"Thread-error == %@",error.localizedDescription);
                [SVProgressHUD dismiss];
            }
            return ;
        }
        
        
        if([msg isEqualToString:@"tokenRefreshed"]){
            
            [self getImpactDetails];
            
            return;
        }
        
        if (json) {
            
            //   [SVProgressHUD dismiss];
            NSLog(@"JSON is : %@",json);
            
            if([json isKindOfClass:[NSDictionary class]]){
                
                if (json[@"data"]){
                    
                    self->globalVariables.impactValue = [json objectForKey:@"data"];
                }else{
                    self->globalVariables.impactValue=@"Details are not added.";
                }
                
            }
            else{
                
                self->globalVariables.impactValue=@"Details are not added.";
            }
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self->_impactTextView.text = [NSString stringWithFormat:@"%@",self->globalVariables.impactValue];
                    
                    
                });
            });
            
        }
        
    }];
    
}

-(void)getSymptomsDetails{
    
    NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/get/updates/%@/sd_problem/symptoms?token=%@&",[userDefaults objectForKey:@"baseURL"],globalVariables.problemId,[userDefaults objectForKey:@"token"]];
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
                //NSLog(@"Thread-error == %@",error.localizedDescription);
                [SVProgressHUD dismiss];
            }
            return ;
        }
        
        
        if([msg isEqualToString:@"tokenRefreshed"]){
            
            [self getSymptomsDetails];
            
            return;
        }
        
        if (json) {
            
            //   [SVProgressHUD dismiss];
            NSLog(@"JSON is : %@",json);
            
            if([json isKindOfClass:[NSDictionary class]]){
                
                if (json[@"data"]){
                    
                    self->globalVariables.symptomsValue = [json objectForKey:@"data"];
                }else{
                    self->globalVariables.symptomsValue=@"Details are not added.";
                }
                
            }
            else{
                
                self->globalVariables.symptomsValue=@"Details are not added.";
            }
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self->_symptomsTextView.text = [NSString stringWithFormat:@"%@",self->globalVariables.symptomsValue];
                    
                    
                });
            });
            
        }
        
    }];

}

-(void)getSolutionDetails{
    
    NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/get/updates/%@/sd_problem/solution?token=%@&",[userDefaults objectForKey:@"baseURL"],globalVariables.problemId,[userDefaults objectForKey:@"token"]];
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
                //NSLog(@"Thread-error == %@",error.localizedDescription);
                [SVProgressHUD dismiss];
            }
            return ;
        }
        
        
        if([msg isEqualToString:@"tokenRefreshed"]){
            
            [self getSolutionDetails];
            
            return;
        }
        
        if (json) {
            
            //   [SVProgressHUD dismiss];
            NSLog(@"JSON is : %@",json);
            
            if([json isKindOfClass:[NSDictionary class]]){
                
                if (json[@"data"]){
                    
                    self->globalVariables.solutionValue = [json objectForKey:@"data"];
                }else{
                    self->globalVariables.solutionValue=@"Details are not added.";
                }
                
            }
            else{
                
                self->globalVariables.solutionValue=@"Details are not added.";
            }
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self->_solutionTextView.text = [NSString stringWithFormat:@"%@",self->globalVariables.solutionValue];
                    [SVProgressHUD dismiss];
                    
                });
            });
            
        }
        
    }];
    
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
    [self viewDidLoad];
    //    [refresh endRefreshing];
}


@end
