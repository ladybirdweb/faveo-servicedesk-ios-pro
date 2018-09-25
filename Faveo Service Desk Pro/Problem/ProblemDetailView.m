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
#import "OpenCloseTableViewCell.h"
#import "AssetCell.h"
#import "ProblemList.h"

@interface ProblemDetailView ()<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;

}

@property (nonatomic, strong) LPSemiModalView *normalModalView1;
@property (nonatomic, strong) LPSemiModalView *normalModalView2;
@property (nonatomic, strong) LPSemiModalView *normalModalView3;
@property (nonatomic, strong) LPSemiModalView *normalModalView4;
@property (nonatomic, strong) LPSemiModalView *normalModalView5;

//It is used to show table view as a modal for displaying tickets and assets
@property (strong, nonatomic) UITableView *tableView1;
@property (strong, nonatomic) UITableView *tableView2;


@property (nonatomic) int count1;

@end

@implementation ProblemDetailView

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.segmentedControl.tintColor=[UIColor hx_colorWithHexRGBAString:@"#00aeef"];
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
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
    
    
    
    // ************** modal view 1 for showing tickets ************************
    
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
    labelView.text = @"Asssociated Tickets";
  //  labelView.textColor = [UIColor colorFromHexString:@"CCCCCC"];
    labelView.textColor = [UIColor whiteColor];
    
    [headerView addSubview:labelView];
    _tableView1.tableHeaderView = headerView;
    
    // end creating header
    
    
     self.normalModalView1.narrowedOff = YES;
     self.normalModalView1.backgroundColor = [UIColor whiteColor];
    
    
    // ************** end modal view 1 for showing tickets ***********************
    
    
    
    // ************** modal view 2 for showing assets ************************
    
    self.normalModalView2 = [[LPSemiModalView alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, 230) andBaseViewController:self];
    //  self.normalModalView.contentView.backgroundColor = [UIColor yellowColor];
    
    
    // init table view
    _tableView2 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    
    
  //  _tableView2.backgroundColor = [UIColor lightGrayColor];
    
    // add to canvas
    [self.normalModalView2.contentView addSubview:_tableView2];
    
    
    // creating header
    UIView *headerView2 = [[UIView alloc] initWithFrame:CGRectMake(1, 50, 276, 45)];
   // headerView2.backgroundColor = [UIColor colorFromHexString:@"EFEFF4"];
    headerView2.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *labelView2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 13, 300, 24)];
    labelView2.text = @"Asssociated Assets";
   // labelView2.textColor = [UIColor colorFromHexString:@"CCCCCC"];
    labelView2.textColor = [UIColor whiteColor];
    
    [headerView2 addSubview:labelView2];
    _tableView2.tableHeaderView = headerView2;
    
    // end creating header
     
    
    self.normalModalView2.narrowedOff = YES;
    self.normalModalView2.backgroundColor = [UIColor whiteColor];
    
    
    // ************** end modal view 2 for showing tickets ***********************
    
    
    // **************** modal view 3 for change ******************************
    
    self.normalModalView3 = [[LPSemiModalView alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, 150) andBaseViewController:self];
    //  self.normalModalView.contentView.backgroundColor = [UIColor yellowColor];
    
    
    UILabel *label0;
    UILabel *label1;
    UILabel *label2;
    
    //  x  y    w   h
    label0=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 13)];
    label1=[[UILabel alloc]initWithFrame:CGRectMake(53, 50, 150, 40)];//Set frame of label in your viewcontroller.
    label2=[[UILabel alloc]initWithFrame:CGRectMake(53, 90, 150, 40)];
    
    
    [label1 setText:@"New Change"];//Set text in label.
    [label2 setText:@"Existing Change"];
    [label0 setText:@"MANAGE CHANGE"];
    
    label1.userInteractionEnabled = YES;
    label2.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newChangeMethod)];
    UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(existingChangeMethod)];
    
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
    
    [self.normalModalView3.contentView addSubview:label0];
    [self.normalModalView3.contentView addSubview:label1];
    [self.normalModalView3.contentView addSubview:label2];
    
    
    
    UIImageView *imageview1 = [[UIImageView alloc]
                               initWithFrame:CGRectMake(16, 59, 25, 25)];
    [imageview1 setImage:[UIImage imageNamed:@"create_ticket"]];
    [imageview1 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView3.contentView addSubview:imageview1];
    
    UIImageView *imageview2 = [[UIImageView alloc]
                               initWithFrame:CGRectMake(16, 98, 25, 25)];
    [imageview2 setImage:[UIImage imageNamed:@"AddCC"]];
    [imageview2 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView3.contentView addSubview:imageview2];
    
    
    self.normalModalView3.narrowedOff = YES;
    //below line is the most important line, if you do not write below line then top view and the view below navigation bar will show in balck color, aslo an segemented control also shown in black color. So what I am doing here, I am changing the background color of modal view so that when I come to problem detail page, I can able to see normal screen.
  //  self.normalModalView3.backgroundColor = [UIColor whiteColor];
    
   // **************** end modal view 3 for change *************************************
    

   //***************** modal view 4 for update *******************************************
    
    
    self.normalModalView4 = [[LPSemiModalView alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, 230) andBaseViewController:self];
    //  self.normalModalView.contentView.backgroundColor = [UIColor yellowColor];
    
    UILabel *label00;
    UILabel *label11;
    UILabel *label22;
    UILabel *label33;
    UILabel *label44;
    
    //  x  y    w   h
    label00=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 200, 13)];
    label11=[[UILabel alloc]initWithFrame:CGRectMake(58, 50, 150, 40)];//Set frame of label in your viewcontroller.
    label22=[[UILabel alloc]initWithFrame:CGRectMake(58, 90, 150, 40)];
    label33=[[UILabel alloc]initWithFrame:CGRectMake(58, 130, 150, 40)];
    label44=[[UILabel alloc]initWithFrame:CGRectMake(58, 170, 150, 40)];
    
    
    [label11 setText:@"Root Cause"];//Set text in label.
    [label22 setText:@"Impact"];
    [label33 setText:@"Symptoms"];
    [label44 setText:@"Solution"];
    [label00 setText:@"UPDATE"];
    
    label11.userInteractionEnabled = YES;
    label22.userInteractionEnabled = YES;
    label33.userInteractionEnabled = YES;
    label44.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture11 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rootCauseMethodCall)];
    UITapGestureRecognizer * tapGesture22 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(impactMethodCall)];
    UITapGestureRecognizer * tapGesture33 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(symptomsMethodCall)];
    UITapGestureRecognizer * tapGesture44 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(solutionMethodCall)];
    
    [label11 addGestureRecognizer:tapGesture11];
    [label22 addGestureRecognizer:tapGesture22];
    [label33 addGestureRecognizer:tapGesture33];
    [label44 addGestureRecognizer:tapGesture44];
    
    
    [label00 setTextColor:[UIColor colorFromHexString:@"CCCCCC"]];
    [label11 setTextColor:[UIColor blackColor]];//Set text color in label.
    [label22 setTextColor:[UIColor blackColor]];
    [label33 setTextColor:[UIColor blackColor]];
    [label44 setTextColor:[UIColor blackColor]];
    
    [label00 setTextAlignment:NSTextAlignmentLeft];
    [label11 setTextAlignment:NSTextAlignmentLeft];//Set text alignment in label.
    [label22 setTextAlignment:NSTextAlignmentLeft];//Set text alignment in label.
    [label33 setTextAlignment:NSTextAlignmentLeft];
    [label44 setTextAlignment:NSTextAlignmentLeft];
    
    [label11 setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [label11 setLineBreakMode:NSLineBreakByCharWrapping];//Set linebreaking mode..
    // [label setNumberOfLines:1];//Set number of lines in label.
    
    [self.normalModalView4.contentView addSubview:label00];
    [self.normalModalView4.contentView addSubview:label11];
    [self.normalModalView4.contentView addSubview:label22];
    [self.normalModalView4.contentView addSubview:label33];
    [self.normalModalView4.contentView addSubview:label44];
    
    
    
    UIImageView *imageview11 = [[UIImageView alloc]
                               initWithFrame:CGRectMake(21, 59, 23, 23)];
    [imageview11 setImage:[UIImage imageNamed:@"rootCause"]];
    [imageview11 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView4.contentView addSubview:imageview11];
    
    UIImageView *imageview22 = [[UIImageView alloc]
                               initWithFrame:CGRectMake(24, 100, 20, 20)];
    [imageview22 setImage:[UIImage imageNamed:@"impact"]];
    [imageview22 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView4.contentView addSubview:imageview22];
    
    UIImageView *imageview33 = [[UIImageView alloc]
                               initWithFrame:CGRectMake(21, 140, 25, 25)];
    [imageview33 setImage:[UIImage imageNamed:@"symptoms"]];
    [imageview33 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView4.contentView addSubview:imageview33];
    
    UIImageView *imageview44 = [[UIImageView alloc]
                               initWithFrame:CGRectMake(21, 178, 28, 28)];
    [imageview44 setImage:[UIImage imageNamed:@"solution"]];
    [imageview44 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView4.contentView addSubview:imageview44];
    
    
    self.normalModalView4.narrowedOff = YES;
  //  self.normalModalView4.backgroundColor = [UIColor whiteColor];
    
    
   //***************** end modal view 4 ************************************************

   //***************** modal view 5 for more ************************************************
    
    //self.title = @"LPSemiModalView";
    self.normalModalView5 = [[LPSemiModalView alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, 190) andBaseViewController:self];
    //  self.normalModalView.contentView.backgroundColor = [UIColor yellowColor];
    
    UILabel *label0A;
    UILabel *label1A;
    UILabel *label2A;
    UILabel *label3A;
    
    
                                                   //  x  y    w   h
    label0A=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 200, 13)];
    label1A=[[UILabel alloc]initWithFrame:CGRectMake(58, 50, 150, 40)];//Set frame of label in your viewcontroller.
    label2A=[[UILabel alloc]initWithFrame:CGRectMake(58, 90, 150, 40)];
    label3A=[[UILabel alloc]initWithFrame:CGRectMake(58, 130, 150, 40)];
    
    
    
    [label1A setText:@"Edit"];//Set text in label.
    [label2A setText:@"Close"];
    [label3A setText:@"Delete"];
    

    label1A.userInteractionEnabled = YES;
    label2A.userInteractionEnabled = YES;
    label3A.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture1A = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editMethodCalled)];
    UITapGestureRecognizer * tapGesture2A = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMethodCalled)];
    UITapGestureRecognizer * tapGesture3A = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteMethodCalled)];
    
    [label1A addGestureRecognizer:tapGesture1A];
    [label2A addGestureRecognizer:tapGesture2A];
    [label3A addGestureRecognizer:tapGesture3A];
    
    
    [label0A setText:@"..."];
    
    [label0A setTextColor:[UIColor colorFromHexString:@"CCCCCC"]];
    [label1A setTextColor:[UIColor blackColor]];//Set text color in label.
    [label2A setTextColor:[UIColor blackColor]];
    [label3A setTextColor:[UIColor blackColor]];
    
    
    [label0A setTextAlignment:NSTextAlignmentLeft];
    [label1A setTextAlignment:NSTextAlignmentLeft];//Set text alignment in label.
    [label2A setTextAlignment:NSTextAlignmentLeft];//Set text alignment in label.
    [label3A setTextAlignment:NSTextAlignmentLeft];
    
    
    [label1A setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [label1A setLineBreakMode:NSLineBreakByCharWrapping];//Set linebreaking mode..
    // [label setNumberOfLines:1];//Set number of lines in label.
    
    [self.normalModalView5.contentView addSubview:label0A];
    [self.normalModalView5.contentView addSubview:label1A];
    [self.normalModalView5.contentView addSubview:label2A];
    [self.normalModalView5.contentView addSubview:label3A];
    
    
    
    
    UIImageView *imageview1A = [[UIImageView alloc]
                               initWithFrame:CGRectMake(21, 59, 25, 25)];
    [imageview1A setImage:[UIImage imageNamed:@"pencileEdit"]];
    [imageview1A setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView5.contentView addSubview:imageview1A];
    
    UIImageView *imageview2A = [[UIImageView alloc]
                               initWithFrame:CGRectMake(21, 98, 25, 25)];
    [imageview2A setImage:[UIImage imageNamed:@"closeticket2"]];
    [imageview2A setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView5.contentView addSubview:imageview2A];
    
    UIImageView *imageview3A = [[UIImageView alloc]
                               initWithFrame:CGRectMake(21, 140, 25, 25)];
    [imageview3A setImage:[UIImage imageNamed:@"trash2"]];
    [imageview3A setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView5.contentView addSubview:imageview3A];
    
    
    
    
    self.normalModalView5.narrowedOff = YES;
  //  self.normalModalView4.backgroundColor = [UIColor whiteColor];
    
    //************* end modal view 5 for more **********************************************
    
    [self callProbleDetailAPI];
    
}

//-(void)viewWillAppear:(BOOL)animated{
//
//    [self callProbleDetailAPI];
//
//}



-(void)newChangeMethod{
    
    NSLog(@"new change clicked");
}

-(void)existingChangeMethod{
    
     NSLog(@"existing change clicked");
}

-(void)rootCauseMethodCall{
    
    NSLog(@"root cause clicked");
}

-(void)impactMethodCall{
    
     NSLog(@"impact method clicked");
}

-(void)symptomsMethodCall{
    
    NSLog(@"symptoms  method clicked");
}


-(void)solutionMethodCall{
    
     NSLog(@"solution method clicked");
}

-(void)editMethodCalled{
    
    NSLog(@"edit  method clicked");
    [self.normalModalView5 close];
    
    EditProblemDetails *editProblem=[self.storyboard instantiateViewControllerWithIdentifier:@"EditProblemDetailsId"];
    [self.navigationController pushViewController:editProblem animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(void)closeMethodCalled{
    
    NSLog(@"closed method clicked");
    [self.normalModalView5 close];
    
    
}

-(void)deleteMethodCalled{
    
    NSLog(@"delete method clicked");
    [self.normalModalView5 close];
    
    [SVProgressHUD showWithStatus:@"Deleting Problem"];
    [self deleteProblemAPICall];
}


-(void)deleteProblemAPICall{
    
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
        
        NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/problem/delete/%@?token=%@",[userDefaults objectForKey:@"baseURL"],globalVariables.problemId,[userDefaults objectForKey:@"token"]];
        
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
                       
                        [SVProgressHUD dismiss];
                    }
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    
                    [self deleteProblemAPICall];
                    NSLog(@"Thread-delete-problem-api-call");
                    return;
                }
                
        
                
                if (json) {
                    
                    NSString * msg = [json objectForKey:@"data"];
                
                    if([msg isEqualToString:@"Problem Deleted Successfully."]){
                       
                        if (self.navigationController.navigationBarHidden) {
                            [self.navigationController setNavigationBarHidden:NO];
                        }
                        
                        [RMessage showNotificationInViewController:self.navigationController
                                                             title:NSLocalizedString(@"success", nil)
                                                          subtitle:NSLocalizedString(@"Ticket created successfully.", nil)
                                                         iconImage:nil
                                                              type:RMessageTypeSuccess
                                                    customTypeName:nil
                                                          duration:RMessageDurationAutomatic
                                                          callback:nil
                                                       buttonTitle:nil
                                                    buttonCallback:nil
                                                        atPosition:RMessagePositionNavBarOverlay
                                              canBeDismissedByUser:YES];
                        
                        // [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
                        
                        ProblemList *problemVC=[self.storyboard instantiateViewControllerWithIdentifier:@"problemId"];
                        [self.navigationController pushViewController:problemVC animated:YES];
                        
                    }else{
                      
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Someting went wrong. Please try again later.."] sendViewController:self];
                        [SVProgressHUD dismiss];
                        
                        
                    }
                    
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
            NSLog( @" I am in delete problem method in problem detail VC" );
            
            
        }
    }
    
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
                    
                    self->globalVariables.asstArray = [problemList objectForKey:@"asset"];
                    
                  //NSLog(@"Values of count is : %lu",(unsigned long)[assetArray count]);
                    
                  //showing asset count
                    self->_assetBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[self->globalVariables.asstArray count]];
                    
                    
                 //  self->ticketArray = [problemList objectForKey:@"tickets"];
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
        
        [self.normalModalView1 open];
        
    }
    else if(item.tag == 2) {
        //your code for tab item 2
        NSLog(@"clicked on 2");
        //NSLog(@"Array is : %@",globalVariables.asstArray);
        [self.normalModalView2 open];
        
    }
    else if(item.tag == 3) {
        //your code for tab item 3
        NSLog(@"clicked on 3");
        
        [self.normalModalView3 open];
    }
    else if(item.tag == 4) {
        //your code for tab item 4
        NSLog(@"clicked on 4");
        
        [self.normalModalView4 open];
    }
    else if(item.tag == 5) {
        //your code for tab item 5
        NSLog(@"clicked on 5");
        [self.normalModalView5 open];
    }else{
        
        NSLog(@"something went wrong");
        
    }
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
    if(theTableView == _tableView1){
    
        return 5;
    }
   
    if(theTableView == _tableView2){
    return [globalVariables.asstArray count];
        
    }
    
    return 0;
   // return 3;
}


// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    if(theTableView == _tableView1){


    OpenCloseTableViewCell *cell=[theTableView dequeueReusableCellWithIdentifier:@"OpenCloseTableViewID"];

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OpenCloseTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.ticketNumberLbl.text = @"AAAA-BBBB-0111";
    cell.ticketSubLbl.text = @"This is the ticket title";

    return cell;

    }
    
  

 //  else  if(theTableView == _tableView2){
  
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
    
//    }
//
//    return nil;
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


@end
