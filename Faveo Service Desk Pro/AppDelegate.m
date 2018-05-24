//
//  AppDelegate.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 21/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "InboxViewController.h"
#import "NaviagtionController.h"
#import "SideMenuViewController.h"
#import "LoginViewController.h"
#import "RootViewController.h"
#import "REFrostedViewController.h"


//@import Firebase;

@interface AppDelegate ()
{
    UIStoryboard *mainStoryboard;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
  //  [FIRApp configure];
    
    
    
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginSuccess"]) {
        NSLog(@"Login Done!!!");
        
        // Instantiating Inbox view controller when App starts (If already Logged in an user)
        InboxViewController *inboxVC=[mainStoryboard  instantiateViewControllerWithIdentifier:@"inboxID"];
        
        NaviagtionController *nav = [[NaviagtionController alloc] initWithRootViewController:inboxVC];
        
        // Initialise side-menu view controller
        SideMenuViewController *menuController = [[SideMenuViewController alloc] initWithStyle:UITableViewStylePlain];

        // Create frosted view controller
        REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:nav menuViewController:menuController];
        frostedViewController.direction = REFrostedViewControllerDirectionLeft;
        
        // Make it a root controller
        self.window.rootViewController = frostedViewController;
        
    }
    else{
        // If not Logged in then instantiate with login page (Enter URL view)
        LoginViewController *loginVC=[mainStoryboard  instantiateViewControllerWithIdentifier:@"inboxID"];
        
        NaviagtionController *nav = [[NaviagtionController alloc] initWithRootViewController:loginVC];
        nav.navigationBar.translucent = NO;
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
