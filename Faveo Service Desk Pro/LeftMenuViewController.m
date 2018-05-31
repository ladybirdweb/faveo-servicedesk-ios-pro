//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"


@interface LeftMenuViewController (){
    NSUserDefaults *userDefaults;
//    GlobalVariables *globalVariables;
//    Utils *utils;
    UIRefreshControl *refresh;
}

@end

@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	
	return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.separatorColor = [UIColor lightGrayColor];
	
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    //[self.tableView reloadData]
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIViewController *vc ;
    
    @try{
        switch (indexPath.row)
        {
            case 1:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"CreateTicket"];
                break;
                
            case 2:
                [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                break;
            case 3:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InboxID"];
                break;
            case 4:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InboxID"];
                break;
            case 5:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InboxID"];
                break;
            case 6:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InboxID"];
                break;
                
            case 7:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InboxID"];
                break;
                
            case 8:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InboxID"];
               // globalVariables.userFilterId=@"ALLUSERS";
                break;
                
            case 10:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InboxID"];
                break;
                
            case 11:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InboxID"];
                break;
                
                
            case 12:
                
                [self wipeDataInLogout];
                
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"Login"];
            
                break;
                
            default:
                break;
        }
    }@catch (NSException *exception)
    {
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
      //  [utils showAlertWithMessage:exception.name sendViewController:self];
        return;
    }
    @finally
    {
        NSLog( @" I am in did-deselect method in Leftmenu ViewController" );
        
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 9) {
        return 0;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}


-(void)wipeDataInLogout
{
     [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
}

@end
