//
//  ViewAttachedProblems.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 26/09/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "ViewAttachedProblems.h"
#import "Utils.h"
#import "GlobalVariables.h"
#import "AppDelegate.h"
#import "MyWebservices.h"
#import "SVProgressHUD.h"
#import "ProblemTableViewCell.h"
#import "UIColor+HexColors.h"
#import "ProblemDetailView.h"
#import "AppConstanst.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "TicketDetailViewController.h"
#import "InboxTickets.h"
#import "SampleNavigation.h"
#import "ExpandableTableViewController.h"
#import "SWRevealViewController.h"


@interface ViewAttachedProblems ()<RMessageProtocol>
{
    GlobalVariables *globalvariable;
    NSUserDefaults *userDefaults;
    Utils *utils;
    
}

@end

@implementation ViewAttachedProblems

- (void)viewDidLoad {
    [super viewDidLoad];
    
    utils=[[Utils alloc]init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalvariable=[GlobalVariables sharedInstance];
    
    
    _viewButtonOutlet.backgroundColor = [UIColor colorFromHexString:@"00aeef"];
    _detachButtonOutlet.backgroundColor = [UIColor colorFromHexString:@"00aeef"];
    
   
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

-(void)viewWillAppear:(BOOL)animated
{
    utils=[[Utils alloc]init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalvariable=[GlobalVariables sharedInstance];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

// This method tells the delegate the table view is about to draw a cell for a particular row
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
}
// This method asks the data source for a cell to insert in a particular location of the table view.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        ProblemTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"problemCellId"];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProblemTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
    
    
     NSLog(@"Attached Problem Details are : %@",globalvariable.attachedProblemDataDict);
     NSLog(@"Attached Problem Details are : %@",globalvariable.attachedProblemDataDict);
    
    
        NSDictionary *finaldic= globalvariable.attachedProblemDataDict;
    
        NSString *problemName= [finaldic objectForKey:@"subject"];
        NSString *from= [finaldic objectForKey:@"from"];
        NSString *id= [finaldic objectForKey:@"id"];

        cell.problemNameLabel.text = [NSString stringWithFormat:@"%@",problemName];
        cell.fromLabel.text = [NSString stringWithFormat:@"Requester: %@",from]; //from;
        cell.problemNumber.text = [NSString stringWithFormat:@"#PRB-%@",id];
        cell.createdDateLabel.text = @"";
        cell.indicationView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        cell.mainView.backgroundColor = [UIColor colorFromHexString:@"EFEFF4"];
    
        return cell;
    
    
}


- (IBAction)viewButtonClicked:(id)sender {
    
    NSLog(@"Clicked on view button");

    NSDictionary *finaldic= globalvariable.attachedProblemDataDict;

    globalvariable.problemId=[finaldic objectForKey:@"id"];
    globalvariable.showNavigationItem=@"show";
    
    ProblemDetailView *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"ProblemDetailViewId"];
    UINavigationController *objNav = [[UINavigationController alloc] initWithRootViewController:detail];
    [self presentViewController:objNav animated:YES completion:nil];
    
   // [ dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)detachButtonClicked:(id)sender {
    
    NSLog(@"Clicked on detach button");
    [SVProgressHUD showWithStatus:@"Detaching Problem"];
    [self dettachProblemAPICall];
    
}

-(void)dettachProblemAPICall{
    
    NSDictionary *finaldic= globalvariable.attachedProblemDataDict;
    
    globalvariable.problemId=[finaldic objectForKey:@"id"];
    
    
    NSString * url= [NSString stringWithFormat:@"%@api/v1/servicedesk/detach/problem/ticket?token=%@&api_key=%@&ticketid=%@&problemid=%@",[userDefaults objectForKey:@"baseURL"],[userDefaults objectForKey:@"token"],API_KEY,globalvariable.ticketId,globalvariable.problemId];
    NSLog(@"URL is : %@",url);
    
    @try{
        MyWebservices *webservices=[MyWebservices sharedInstance];
        
        [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
            
            
            if (error || [msg containsString:@"Error"]) {
                
                [SVProgressHUD dismiss];
                
                if (msg) {
                        
                        NSLog(@"Message is : %@",msg);
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                        [SVProgressHUD dismiss];
                    
                }else if(error)  {
                    NSLog(@"Error is : %@",error);
                    
                    [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                  //  NSLog(@"Thread-AllProbelms-Refresh-error == %@",error.localizedDescription);
                    [SVProgressHUD dismiss];
                }
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                
                [self dettachProblemAPICall];
                return;
            }
            
            
            
            if (json) {
                
                NSLog(@"%@",json);
                
                NSString * dataMesg = [json objectForKey:@"data"];
                
                if([dataMesg isEqualToString:@"Detached Successfully"]){
                
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (self.navigationController.navigationBarHidden) {
                                [self.navigationController setNavigationBarHidden:NO];
                            }
                            
                            [RMessage showNotificationInViewController:self.navigationController
                                                                 title:NSLocalizedString(@"success", nil)
                                                              subtitle:NSLocalizedString(@"Detached Successfully.", nil)
                                                             iconImage:nil
                                                                  type:RMessageTypeSuccess
                                                        customTypeName:nil
                                                              duration:RMessageDurationAutomatic
                                                              callback:nil
                                                           buttonTitle:nil
                                                        buttonCallback:nil
                                                            atPosition:RMessagePositionNavBarOverlay
                                                  canBeDismissedByUser:YES];
                          
                         //   [self dismissViewControllerAnimated:YES completion:nil];
                          
//                            TicketDetailViewController *td=[self.storyboard instantiateViewControllerWithIdentifier:@"ticketDetailViewId"];
//
//                            InboxTickets *inboxVC=[self.storyboard instantiateViewControllerWithIdentifier:@"inboxId"];
//                            UINavigationController *objNav = [[UINavigationController alloc] initWithRootViewController:inboxVC];
//                            [self presentViewController:objNav animated:YES completion:nil];
//
                            InboxTickets *inboxVC=[self.storyboard instantiateViewControllerWithIdentifier:@"inboxId"];
                            
                            SampleNavigation *slide = [[SampleNavigation alloc] initWithRootViewController:inboxVC];
                            
                            
                            ExpandableTableViewController *sidemenu = (ExpandableTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"sideMenu"];
                            
                            // Initialize SWRevealViewController and set it as |rootViewController|
                            SWRevealViewController * vc= [[SWRevealViewController alloc]initWithRearViewController:sidemenu frontViewController:slide];
                            
                            [self presentViewController:vc animated:YES completion:nil];
                            
                         //   [self.navigationController pushViewController:inboxVC animated:YES];
//
                            [SVProgressHUD dismiss];
                            
                        });
                    });
                    
                    
                    
                }else{
                    
                    [self->utils showAlertWithMessage:@"Something Went Wrong." sendViewController:self];
                    [SVProgressHUD dismiss];
                }
                
               
                
            }
            NSLog(@"Thread-detach-problem-closed");
            
        }];
    }@catch (NSException *exception)
    {
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        [utils showAlertWithMessage:exception.name sendViewController:self];
        return;
    }
    
    
}



@end
