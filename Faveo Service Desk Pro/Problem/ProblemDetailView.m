//
//  ProblemDetailView.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ProblemDetailView.h"
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
#import "EditProblemDetails.h"
#import "LPSemiModalView.h"

@interface ProblemDetailView ()<UITabBarDelegate>
{
    
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
}

@property (nonatomic) int count1;

@end

@implementation ProblemDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.segmentedControl.tintColor=[UIColor hx_colorWithHexRGBAString:@"#00aeef"];
    
   // count=0;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    
    UIButton *editButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"pencileEdit"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editProblem) forControlEvents:UIControlEventTouchUpInside];
    [editButton setFrame:CGRectMake(50, 5, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:editButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    
    self.currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalysisViewId"];
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self callProbleDetailAPI];
    
}


-(void)editProblem{
    
    NSLog(@"Clicked....!");
    
    EditProblemDetails *editProblem=[self.storyboard instantiateViewControllerWithIdentifier:@"EditProblemDetailsId"];
    [self.navigationController pushViewController:editProblem animated:YES];
    
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

// It will handle segmented control selection
- (IBAction)indexChanged:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"Analysis");
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalysisViewId"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    } else {
        NSLog(@"Detail");
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProblemDetailDataId"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    }
    
}


-(void)callProbleDetailAPI{
    
 
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
        
        
        
    }else{
        
        
        NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/problem/editbind/%@?token=%@",[userDefaults objectForKey:@"baseURL"],globalVariables.problemId,[userDefaults objectForKey:@"token"]];
        
        NSLog(@"URL is : %@",url);
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                
                if (error || [msg containsString:@"Error"]) {
                    
                    [SVProgressHUD dismiss];
                    
                    if (msg) {
                        
                        
                        
                        if([msg isEqualToString:@"Error-403"])
                        {
                            [self->utils showAlertWithMessage:NSLocalizedString(@"Access Denied - You don't have permission.", nil) sendViewController:self];
                            
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
                        
                        else{
                            
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                            [SVProgressHUD dismiss];
                        }
                        
                    }else if(error)  {
                        NSLog(@"Error is : %@",error);
                        
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-problem-details-Refresh-error == %@",error.localizedDescription);
                        
                        [SVProgressHUD dismiss];
                    }
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    
                    [self callProbleDetailAPI];
                    NSLog(@"Thread-call-getProblemDetails");
                    return;
                }
                
                if ([msg isEqualToString:@"tokenNotRefreshed"]) {
                    
                    // [self showMessageForLogout:@"Your HELPDESK URL or Your Login credentials were changed, contact to Admin and please log back in." sendViewController:self];
                    
                    [SVProgressHUD dismiss];
                    
                    return;
                }
                
                
                if (json) {
                    
                   NSDictionary *problemList=[json objectForKey:@"data"];
                  
                   NSArray * assetArray = [problemList objectForKey:@"asset"];
                    
                  //NSLog(@"Values of count is : %lu",(unsigned long)[assetArray count]);
                    
                  //showing asset count
                  self->_assetBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[assetArray count]];
                    
                 //showing ticket count
                 // self->_ticketBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[ticketArray count]];
                    self->_ticketBarItem.badgeValue=@"0";
                    
                    
                    [SVProgressHUD dismiss];
                }
                NSLog(@"Thread-problem-detail-closed");
                
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
            NSLog( @" I am in callProbleDetailAPI method in problem detail ViewController" );
            
            
        }
    }
    
    
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if(item.tag == 1) {
        //your code for tab item 1
        NSLog(@"clicked on 1");
    }
    else if(item.tag == 2) {
        //your code for tab item 2
        NSLog(@"clicked on 2");
    }
    else if(item.tag == 3) {
        //your code for tab item 3
        NSLog(@"clicked on 3");
    }
    else if(item.tag == 4) {
        //your code for tab item 4
        NSLog(@"clicked on 4");
    }
    else if(item.tag == 5) {
        //your code for tab item 5
        NSLog(@"clicked on 5");
    }else{
        
        NSLog(@"something went wrong");
    }
}



@end
