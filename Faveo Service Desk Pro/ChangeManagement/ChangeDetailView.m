//
//  ChangeDetailView.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 18/01/19.
//  Copyright © 2019 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ChangeDetailView.h"
#import "ChangeAnalysisView.h"
#import "Utils.h"
#import "MyWebservices.h"
#import "GlobalVariables.h"
#import "SVProgressHUD.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "Reachability.h"
#import "UIColor+HexColors.h"
#import "HexColors.h"
#import "LPSemiModalView.h"
#import "OpenCloseTableViewCell.h"
#import "AssetCell.h"
#import "ChangeList.h"
#import "CNPPopupController.h"
#import "AppConstanst.h" 
#import "EditChangeDetails.h"

@interface ChangeDetailView ()<CNPPopupControllerDelegate,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    
    UITextView *customTextView;
    UILabel *errorMessage;
    
    
}

@property (nonatomic, strong) NSString *successMessage;

@property (nonatomic, strong) LPSemiModalView *normalModalView1;
@property (nonatomic, strong) LPSemiModalView *assetsModalView;

//It is used to show table view as a modal for displaying tickets and assets
@property (strong, nonatomic) UITableView *tableView1;

@property (nonatomic) int count1;

@property (nonatomic, strong) CNPPopupController *popupController;


@end

@implementation ChangeDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Details";
    
    self.segmentedControl.tintColor=[UIColor hx_colorWithHexRGBAString:@"#00aeef"];
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // count=0;
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    
    _changeIdLabel.text=[NSString stringWithFormat:@"#CHN-%@",globalVariables.changeId];
    
    if ([globalVariables.showNavigationItem isEqualToString:@"show2"]) {
        
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backBtnClick:)];
        self.navigationItem.leftBarButtonItem = rightBtn;
        
    }
    
    
    UIButton *editButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"pencileEdit"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editChange) forControlEvents:UIControlEventTouchUpInside];
    [editButton setFrame:CGRectMake(50, 5, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:editButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    
    self.currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeAnalysisViewId"];
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
    
    
    // ************** modal view 2 for showing assets ************************
    
    self.assetsModalView = [[LPSemiModalView alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, 230) andBaseViewController:self];
    //  self.normalModalView.contentView.backgroundColor = [UIColor yellowColor];
    
    
    // init table view
    _tableView1 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    
    
    //  _tableView2.backgroundColor = [UIColor lightGrayColor];
    
    // add to canvas
    [self.assetsModalView.contentView addSubview:_tableView1];
    
    
    // creating header
    UIView *headerView2 = [[UIView alloc] initWithFrame:CGRectMake(1, 50, 276, 45)];
    // headerView2.backgroundColor = [UIColor colorFromHexString:@"EFEFF4"];
    headerView2.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *labelView2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 13, 300, 24)];
    labelView2.text = @"Asssociated Assets";
    // labelView2.textColor = [UIColor colorFromHexString:@"CCCCCC"];
    labelView2.textColor = [UIColor whiteColor];
    
    [headerView2 addSubview:labelView2];
    _tableView1.tableHeaderView = headerView2;
    
    // end creating header
    
    
    self.assetsModalView.narrowedOff = YES;
    self.assetsModalView.backgroundColor = [UIColor whiteColor];
    
    
    // ************** end modal view 2 for showing assets ***********************
    
    //***************** modal view 4 for update *******************************************
    
    
    self.normalModalView1 = [[LPSemiModalView alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, 230) andBaseViewController:self];
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
    
    
    [label11 setText:@"Reason for Change"];//Set text in label.
    [label22 setText:@"Impact"];
    [label33 setText:@"Rollout Plan"];
    [label44 setText:@"Backout Plan"];
    [label00 setText:@"UPDATE"];
    
    label11.userInteractionEnabled = YES;
    label22.userInteractionEnabled = YES;
    label33.userInteractionEnabled = YES;
    label44.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture11 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateReasonMethodCall)];
    UITapGestureRecognizer * tapGesture22 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateImpactMethodCall)];
    UITapGestureRecognizer * tapGesture33 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateRolloutPlanMethodCall)];
    UITapGestureRecognizer * tapGesture44 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateBackoutPlanMethodCall)];
    
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
    
    [self.normalModalView1.contentView addSubview:label00];
    [self.normalModalView1.contentView addSubview:label11];
    [self.normalModalView1.contentView addSubview:label22];
    [self.normalModalView1.contentView addSubview:label33];
    [self.normalModalView1.contentView addSubview:label44];
    
    
    
    UIImageView *imageview11 = [[UIImageView alloc]
                                initWithFrame:CGRectMake(21, 59, 23, 23)];
    [imageview11 setImage:[UIImage imageNamed:@"rootCause"]];
    [imageview11 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView1.contentView addSubview:imageview11];
    
    UIImageView *imageview22 = [[UIImageView alloc]
                                initWithFrame:CGRectMake(24, 100, 20, 20)];
    [imageview22 setImage:[UIImage imageNamed:@"impact"]];
    [imageview22 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView1.contentView addSubview:imageview22];
    
    UIImageView *imageview33 = [[UIImageView alloc]
                                initWithFrame:CGRectMake(21, 140, 25, 25)];
    [imageview33 setImage:[UIImage imageNamed:@"symptoms"]];
    [imageview33 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView1.contentView addSubview:imageview33];
    
    UIImageView *imageview44 = [[UIImageView alloc]
                                initWithFrame:CGRectMake(21, 178, 28, 28)];
    [imageview44 setImage:[UIImage imageNamed:@"solution"]];
    [imageview44 setContentMode:UIViewContentModeScaleAspectFit];
    [self.normalModalView1.contentView addSubview:imageview44];
    
    
    self.normalModalView1.narrowedOff = YES;
    self.normalModalView1.backgroundColor = [UIColor whiteColor];
    
    
    //***************** end modal view 4 ************************************************
    
    [self getChangeDetailDataAPICall];
    
}



-(void)editChange{
  
    EditChangeDetails *edit=[self.storyboard instantiateViewControllerWithIdentifier:@"EditChangeDetailsId"];
    [self.navigationController pushViewController:edit animated:YES];
    
}

-(void)backBtnClick:(UIBarButtonItem*)item{
    globalVariables.showNavigationItem =@"";
    [self dismissViewControllerAnimated:YES completion:nil];
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
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeAnalysisViewId"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    } else {
        NSLog(@"Detail");
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeDetailDataId"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    }
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if(item.tag == 1) {
        
        NSLog(@"Clicked on assets");
        
        self.assetsModalView.backgroundColor = [UIColor whiteColor];
        self.assetsModalView.backgroundColor = [UIColor whiteColor];
        
        if([globalVariables.assetStatusInChangeDetailVC isEqualToString:@"NotFound"]){
            
            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"No Assets Found"] sendViewController:self];
            [self.assetsModalView close];
            
        }else{
            
            [self.assetsModalView open];
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView1 reloadData];
                    [self.tableView1 reloadData];
                    [SVProgressHUD dismiss];
                    
                });
            });
        }
        
    }
    else if(item.tag == 2) {
        
        NSLog(@"Clicked on release");
        
    }
    else if(item.tag == 3) {
        
        NSLog(@"Clicked on update");
        [self.normalModalView1 open];
    }
    else if(item.tag == 4) {
        
        NSLog(@"Clicked on delete change");
        [self askConfirmationForDeletingChange];
        
    }
    else if(item.tag == 5) {
        
        NSLog(@"Clicked on edit change");
        
        EditChangeDetails *edit=[self.storyboard instantiateViewControllerWithIdentifier:@"EditChangeDetailsId"];
        [self.navigationController pushViewController:edit animated:YES];
    }
    else{
        
        NSLog(@"something went wrong");
        
    }
}

-(void)askConfirmationForDeletingChange
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Deleting Change"
                                 message:@"Are you sure you want to delete change?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    
                                    NSLog(@"Clicked on Yes");
                                   
                                    [SVProgressHUD showWithStatus:@"Deleting Change"];
                                    [self deleteChangeAPICalled];
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   
                                 NSLog(@"Clicked on No");
                                   
                               }];
    
    //Add your buttons to alert controller
    
     [alert addAction:noButton];
     [alert addAction:yesButton];
   
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)deleteChangeAPICalled{
    
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
        
        NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/change/delete/%@?token=%@",[userDefaults objectForKey:@"baseURL"],globalVariables.changeId,[userDefaults objectForKey:@"token"]];
        
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
                    
                    
                    [self deleteChangeAPICalled];
                    NSLog(@"Thread-delete-change-api-call");
                    return;
                }
                
                
                
                if (json) {
                    
                    NSString * msg = [json objectForKey:@"data"];
                    
                    if([msg isEqualToString:@"Changes Deleted."]){
                        
                        if (self.navigationController.navigationBarHidden) {
                            [self.navigationController setNavigationBarHidden:NO];
                        }
                        
                        [RMessage showNotificationInViewController:self.navigationController
                                                             title:NSLocalizedString(@"success", nil)
                                                          subtitle:NSLocalizedString(@"Change Deleted Successfully.", nil)
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
                        
                        ChangeList *changeVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangeListId"];
                        [self.navigationController pushViewController:changeVC animated:YES];
                        
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
            NSLog( @" I am in delete change method in change detail VC" );
            
            
        }
    }
    
}

-(void)updateReasonMethodCall{
    
    NSLog(@"root cause clicked");
    globalVariables.updateChangeValue=@"reasonForChange";
    
    [self showPopup:CNPPopupStyleCentered];
    [self.normalModalView1 close];
}

-(void)updateImpactMethodCall{
    
    NSLog(@"root cause clicked");
    globalVariables.updateChangeValue=@"impactForChange";
    
    [self showPopup:CNPPopupStyleCentered];
    [self.normalModalView1 close];
}

-(void)updateRolloutPlanMethodCall{
    
    NSLog(@"root cause clicked");
    globalVariables.updateChangeValue=@"rollOut";
    
    [self showPopup:CNPPopupStyleCentered];
    [self.normalModalView1 close];
}

-(void)updateBackoutPlanMethodCall{
    
    NSLog(@"root cause clicked");
    globalVariables.updateChangeValue=@"backOut";
    
    [self showPopup:CNPPopupStyleCentered];
    [self.normalModalView1 close];
}

- (void)showPopup:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title;
    
    if([globalVariables.updateChangeValue isEqualToString:@"reasonForChange"]){
        
        title = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Reason for Change",nil) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    }
    else if([globalVariables.updateChangeValue isEqualToString:@"impactForChange"]){
        
        title = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Impact",nil) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    }
    else if([globalVariables.updateChangeValue isEqualToString:@"rollOut"]){
        
        title = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Rollout Plan",nil) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    }
    else if([globalVariables.updateChangeValue isEqualToString:@"backOut"]){
        
        title = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Backout Plan",nil) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    }else{
        
        NSLog(@"Nothing...!");
    }
    
    
    NSMutableAttributedString *lineTwo = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Description*",nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#00aeef"]}];
    [lineTwo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(11,1)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    errorMessage=[[UILabel alloc] initWithFrame:CGRectMake(10, 135, 250, 20)];
    errorMessage.textColor=[UIColor hx_colorWithHexRGBAString:@"#d50000"];
    errorMessage.text=@"Field is mandatory.";
    [errorMessage setFont:[UIFont systemFontOfSize:12]];
    errorMessage.hidden=YES;
    
    
    UILabel *lineTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    lineTwoLabel.attributedText = lineTwo;
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 140)];
    
    customTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, 250, 100)];
    
    customTextView.layer.cornerRadius=4;
    customTextView.spellCheckingType=UITextSpellCheckingTypeYes;
    customTextView.autocorrectionType=UITextAutocorrectionTypeNo;
    customTextView.layer.borderWidth=1.0F;
    customTextView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    
    [customView addSubview: customTextView];
    [customView addSubview:lineTwoLabel];
    [customView addSubview:errorMessage];
    
    if([globalVariables.updateChangeValue isEqualToString:@"reasonForChange"]){
        
        if([globalVariables.reasonForChangeValue isEqualToString:@"Details are not added."]){
            
            customTextView.text = @"";
        }
        else{
            customTextView.text = [NSString stringWithFormat:@"%@",globalVariables.reasonForChangeValue];
        }
    }
    else if([globalVariables.updateChangeValue isEqualToString:@"impactForChange"]){
        
        if([globalVariables.impactValueForChange isEqualToString:@"Details are not added."]){
            
            customTextView.text = @"";
        }
        else{
            customTextView.text = [NSString stringWithFormat:@"%@",globalVariables.impactValueForChange];
        }
        
    }
    else if([globalVariables.updateChangeValue isEqualToString:@"rollOut"]){
        
        if([globalVariables.rollOutValueForChange isEqualToString:@"Details are not added."]){
            
            customTextView.text = @"";
        }
        else{
            customTextView.text = [NSString stringWithFormat:@"%@",globalVariables.rollOutValueForChange];
        }
        
    }
    else if([globalVariables.updateChangeValue isEqualToString:@"backOut"]){
        
        if([globalVariables.backOutValueForChange isEqualToString:@"Details are not added."]){
            
            customTextView.text = @"";
        }
        else{
            customTextView.text = [NSString stringWithFormat:@"%@",globalVariables.backOutValueForChange];
        }
        
    }else{
        
        customTextView.text=@"";
    }
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0,200
                                                                              
                                                                              , 40)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:NSLocalizedString(@"Done",nil) forState:UIControlStateNormal];
    button.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#00aeef"];
    button.layer.cornerRadius = 4;
    
    button.selectionHandler = ^(CNPPopupButton *button){
        NSString *rawString = [self->customTextView text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
        if ([trimmed length] == 0) {
            self->errorMessage.hidden=NO;
            // Text was empty or only whitespace.
        }else if ( self->customTextView.text.length > 0 && self->customTextView.text != nil && ![self->customTextView.text isEqual:@""]) {
            self->errorMessage.hidden=YES;
            
            [self updateAPICall]; // Update API called - to update Reason for change, Impact, Roll-out and Back-up plan
            
            [self.popupController dismissPopupControllerAnimated:YES];
            NSLog(@"Message is: %@",  self->customTextView.text);
            
        }else {
            self->errorMessage.hidden=NO;
        }
    };
    
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, customView, button]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
    
}

-(void)updateAPICall{
    
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
        
        [SVProgressHUD showWithStatus:@"Please wait"];
        
        NSString *url;
        
        if([globalVariables.updateChangeValue isEqualToString:@"reasonForChange"]){
            
            url=[NSString stringWithFormat:@"%@servicedesk/general/updates/%@/sd_changes?api_key=%@&token=%@&identifier=reason&reason=%@",[userDefaults objectForKey:@"companyURL"],globalVariables.changeId,API_KEY,[userDefaults objectForKey:@"token"],customTextView.text];
            
            NSLog(@"URL is : %@",url);
        }
        else if([globalVariables.updateChangeValue isEqualToString:@"impactForChange"]){
            
            url=[NSString stringWithFormat:@"%@servicedesk/general/updates/%@/sd_changes?api_key=%@&token=%@&identifier=impact&impact=%@",[userDefaults objectForKey:@"companyURL"],globalVariables.changeId,API_KEY,[userDefaults objectForKey:@"token"],customTextView.text];
            
            NSLog(@"URL is : %@",url);
            
        }
        else if([globalVariables.updateChangeValue isEqualToString:@"rollOut"]){
            
            url=[NSString stringWithFormat:@"%@servicedesk/general/updates/%@/sd_changes?api_key=%@&token=%@&identifier=rollout-plan&rollout-plan=%@",[userDefaults objectForKey:@"companyURL"],globalVariables.changeId,API_KEY,[userDefaults objectForKey:@"token"],customTextView.text];
            
            NSLog(@"URL is : %@",url);
        }
        else if([globalVariables.updateChangeValue isEqualToString:@"backOut"]){
            
            url=[NSString stringWithFormat:@"%@servicedesk/general/updates/%@/sd_changes?api_key=%@&token=%@&identifier=backout-plan&backout-plan=%@",[userDefaults objectForKey:@"companyURL"],globalVariables.changeId,API_KEY,[userDefaults objectForKey:@"token"],customTextView.text];
            
            NSLog(@"URL is : %@",url);
            
        }else{
            
            NSLog(@"Nothing Called...!");
        }
        
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            
            [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                if (error || [msg containsString:@"Error"]) {
                    
                    [SVProgressHUD dismiss];
                    
                    if (msg) {
                        
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-updating-change values -error == %@",error.localizedDescription);
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self updateAPICall];
                    return;
                }
                
                if (json) {
                    NSLog(@"JSON-%@",json);
                    
                    if ([json objectForKey:@"data"]) {
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (self.navigationController.navigationBarHidden) {
                                [self.navigationController setNavigationBarHidden:NO];
                            }
                            
                            [RMessage showNotificationInViewController:self.navigationController
                                                                 title:NSLocalizedString(@"Done!", nil)
                                                              subtitle:NSLocalizedString(@"Updated successfully..!", nil)
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
                            [SVProgressHUD dismiss];
                            [self viewDidLoad];
                            
                        });
                    }
                }
                NSLog(@"Thread-updateAPICall-closed");
                
            }];
        }@catch (NSException *exception)
        {
            // Print exception information
            NSLog( @"NSException caught in updateAPICall methods in Change Details VC \n" );
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            return;
        }
        @finally
        {
            // Cleanup, in both success and fail cases
            NSLog( @"In finally block");
            
        }
        
    }
    
    
}


-(void)getChangeDetailDataAPICall{
    
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
        
        
        NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/change/editbind/%@?token=%@",[userDefaults objectForKey:@"baseURL"],globalVariables.changeId,[userDefaults objectForKey:@"token"]];
        
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
                        NSLog(@"Thread-change-details-Refresh-error == %@",error.localizedDescription);
                        
                        [SVProgressHUD dismiss];
                    }
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    
                    [self getChangeDetailDataAPICall];
                    NSLog(@"Thread-call-getChangeDetails");
                    return;
                }
                
                if ([msg isEqualToString:@"tokenNotRefreshed"]) {
                    
                    // [self showMessageForLogout:@"Your HELPDESK URL or Your Login credentials were changed, contact to Admin and please log back in." sendViewController:self];
                    
                    [SVProgressHUD dismiss];
                    
                    return;
                }
                
                
                if (json) {
                    
                    NSDictionary *changeDetailsDict=[json objectForKey:@"data"];
                    
                    self->globalVariables.associatedAssetsWithTheChangeArray = [changeDetailsDict objectForKey:@"assetList"];
                    
                    //NSLog(@"Values of count is : %lu",(unsigned long)[assetArray count]);
                    
                    //showing asset count
                    self->_assetsBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[self->globalVariables.associatedAssetsWithTheChangeArray count]];
                    
                    if([self->globalVariables.associatedAssetsWithTheChangeArray count] ==0){
                        
                        self->globalVariables.assetStatusInChangeDetailVC=@"NotFound";
                        
                    }else{
                        self->globalVariables.assetStatusInChangeDetailVC=@"Found";
                    }
                    
                    
                    [SVProgressHUD dismiss];
                }
                NSLog(@"Thread-change-detail-closed");
                
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
            NSLog( @" I am in getChangeDetailsDatAPI method in problem detail ViewController" );
            
            
        }
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
    
    return [globalVariables.associatedAssetsWithTheChangeArray count];
    
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
    
    NSLog(@"Asset Array is : %@",globalVariables.associatedAssetsWithTheChangeArray);
    
    NSDictionary * assetDict = [globalVariables.associatedAssetsWithTheChangeArray objectAtIndex:indexPath.row];
    
    NSString * id1 = [assetDict objectForKey:@"id"];
    NSString *name = [assetDict objectForKey:@"name"];
    
    cell.assetIdLabel.text = [NSString stringWithFormat:@"#AST-%@",id1];
    cell.assetTitleLabel.text = [NSString stringWithFormat:@"%@",name];
    
    //    cell.assetIdLabel.text = [NSString stringWithFormat:@"#AST-12"];
    //    cell.assetTitleLabel.text = [NSString stringWithFormat:@"Pankaj Macbook Pro"];
    
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

