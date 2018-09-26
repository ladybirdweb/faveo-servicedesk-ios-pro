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

@interface ViewAttachedProblems ()
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

// This method asks the data source for a cell to insert in a particular location of the table view.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        ProblemTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"problemCellId"];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProblemTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
    
        
      NSDictionary *finaldic= globalvariable.attachedProblemDataDict;
    
        NSString *problemName= [finaldic objectForKey:@"subject"];
        NSString *from= [finaldic objectForKey:@"from"];
        NSString *id= [finaldic objectForKey:@"id"];

        cell.problemNameLabel.text = problemName;
        cell.fromLabel.text = [NSString stringWithFormat:@"Requester: %@",from]; //from;
        cell.problemNumber.text = [NSString stringWithFormat:@"#PRB-%@",id];
        cell.createdDateLabel.text = @"";
        cell.indicationView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        cell.mainView.backgroundColor = [UIColor colorFromHexString:@"EFEFF4"];
    
        return cell;
    
    
}



// This method tells the delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];
//    globalVariables.problemId=[finaldic objectForKey:@"id"];
//
//
//    ProblemDetailView *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"ProblemDetailViewId"];
//
//
//    [self.navigationController pushViewController:detail animated:YES];
    
}


- (IBAction)viewButtonClicked:(id)sender {
    
}

- (IBAction)detachButtonClicked:(id)sender {
    
}



@end
