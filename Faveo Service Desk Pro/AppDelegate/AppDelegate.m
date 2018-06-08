//
//  AppDelegate.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 21/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

#import "ExpandableTableViewController.h"
#import "SWRevealViewController.h"
#import "LoginViewController.h"
#import "InboxTickets.h"


#import "SampleNavigation.h"

@interface AppDelegate ()
{
    UIStoryboard *mainStoryboard;
    NSUserDefaults * userDefaults;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginSuccess"]) {
        NSLog(@"Login Done!!!");

        
        InboxTickets *inboxVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"inboxId"];
        
        SampleNavigation *slide = [[SampleNavigation alloc] initWithRootViewController:inboxVC];
       
        
        ExpandableTableViewController *sidemenu = (ExpandableTableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"sideMenu"];
        
        // Initialize SWRevealViewController and set it as |rootViewController|
        SWRevealViewController * vc= [[SWRevealViewController alloc]initWithRearViewController:sidemenu frontViewController:slide];
    

         self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
         self.window.rootViewController = vc;
         [self.window makeKeyAndVisible];
        
    }
    else{

        
        LoginViewController *loginVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
        UINavigationController* navLogin = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        // Using UINavigationController here because you use
        // pushViewController:animated: method in loginButton:
        self.window.rootViewController = navLogin;
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