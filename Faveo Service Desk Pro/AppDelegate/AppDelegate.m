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
#import "IQKeyboardManager.h"
#import <UserNotifications/UserNotifications.h>
#import "MyWebservices.h"
#import "UIColor+HexColors.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@import Firebase;
@import FirebaseMessaging;
@import UserNotifications;
@import FirebaseInstanceID;
@import FirebasePerformance;

#import "SampleNavigation.h"


@interface AppDelegate () <UIApplicationDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate>
{
    UIStoryboard *mainStoryboard;
    NSUserDefaults * userDefaults;
}
@end

NSString *const kGCMMessageIDKey = @"gcm.message_id";


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // [[IQKeyboardManager sharedManager] setEnabled:true];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    //fabric initialization
    [Fabric with:@[[Crashlytics class]]];
    // end
    
    //****Firebase Configuration *********************************
    
    // [START configure_firebase]
    [FIRApp configure];
    
    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = self;
    
     // start tracing // app performance monitoring
    FIRTrace *trace = [FIRPerformance startTraceWithName:@"test trace"];
    //end

    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    // [START register_for_notifications]
    if (@available(iOS 10.0, *)) {
        if ([UNUserNotificationCenter class] != nil) {
            // iOS 10 or later
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
            UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
                 // ...
             }];
        } else {
            // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
           
          
//            UIUserNotificationType allNotificationTypes =
//            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
//            UIUserNotificationSettings *settings =
//            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
//            [application registerUserNotificationSettings:settings];
            
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (!granted) {
                    //Show alert asking to go to settings and allow permission
                }
            }];
        }
        
        
    } else {
        // Fallback on earlier versions
    }
    
    
    //Request a device token from APN services
    [application registerForRemoteNotifications];
    
    
    // Add an observer for handling a token refresh callback
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshCallback:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    [self setApplicationApperance];
    
    //**************************************************************************
    
    
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
    
    [trace stop];  // stop tracing // app performance monitoring
    
    return YES;
}



//// [START receive_message]
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    // If you are receiving a notification message while your app is in the background,
//    // this callback will not be fired till the user taps on the notification launching the application.
//    // TODO: Handle data of notification
//
//    // With swizzling disabled you must let Messaging know about the message, for Analytics
//    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
//
//    // Print message ID.
//    if (userInfo[kGCMMessageIDKey]) {
//        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
//    }
//
//    // Print full message.
//    NSLog(@"%@", userInfo);
//}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"APNs device token retrieved: %@", deviceToken);
    
    //  With swizzling disabled you must set the APNs device token here.
    [FIRMessaging messaging].APNSToken = deviceToken;
    
    // [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeUnknown];
    
    
    NSString *token = [[deviceToken.description componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet]invertedSet]]componentsJoinedByString:@""];
    NSLog(@"deviceToken : %@",deviceToken);
    NSLog(@"final token : %@",[[FIRInstanceID instanceID] token]);
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:@"deviceToken"];
    [userDefaults synchronize];
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Failed to register deviceToken:%@",error.localizedDescription);
    
}



// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    
    
    // Change this to your preferred presentation option
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    
    
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler();
    
    
    // my rest code //pending
    
    
}
// [END ios_10_message_handling]


//
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"userinfo %@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}
// end receive message.


// Receive data message on iOS 10 devices while app is in the foreground.
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received data message: %@", remoteMessage.appData);
    // appData: is The downstream message received by the application.
    // @property(nonatomic, readonly, strong, nonnull) NSDictionary *appData;
}


#pragma mark --Custom Firebase code

// [START refresh_token]
- (void)tokenRefreshCallback:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken =  [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:refreshedToken forKey:@"FCM_TOKEN"];
    [userDefaults synchronize];
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    [self sendDeviceToken:refreshedToken];
    // TODO: If necessary send token to application server.
}
// [END refresh_token]



//-(void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
//    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:fcmToken forKey:@"FCM_TOKEN"];
//    [userDefaults synchronize];
//    // Connect to FCM since connection may have failed when attempted before having a token.
//
//    [self sendDeviceToken:fcmToken];
//
//}


-(void)sendDeviceToken:(NSString*)refreshedToken{
    
    NSLog(@"refreshed token  %@",refreshedToken);
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *url=[NSString stringWithFormat:@"%@fcmtoken?user_id=%@&fcm_token=%@&os=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"user_id"],[[FIRInstanceID instanceID] token],@"ios"];
    MyWebservices *webservices=[MyWebservices sharedInstance];
    [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg){
        if (error || [msg containsString:@"Error"]) {
            if (msg) {
                
                NSLog(@"Thread-postAPNS-toserver-error == %@",error.localizedDescription);
                
            }else if(error)  {
                
                NSLog(@"Thread-postAPNS-toserver-error == %@",error.localizedDescription);
            }
            return ;
        }
        if (json) {
            
            NSLog(@"Thread-sendAPNS-token-json-%@",json);
        }
        
    }];
}

// [START connect_to_fcm]
- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    // Disconnect previous FCM connection if it exists.
   //   [[FIRMessaging messaging] disconnect]; // preveously : 'disconnect' is deprecated: Please use the shouldEstablishDirectChannel property instead.

    
    FIRMessaging.messaging.shouldEstablishDirectChannel=false;
    /* //using swift for disconnecting connection
     func applicationDidEnterBackground(_ application: UIApplication) {
     Messaging.messaging().shouldEstablishDirectChannel = false
     print("Disconnected from FCM.")
     */
    

    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
    
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

//-(BOOL)shouldEstablishDirectChannel
//{
//    return false;
//}

// [START connect_on_active]
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [self connectToFcm];
}
// [END connect_on_active]

// [START disconnect_from_fcm]
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
   // [[FIRMessaging messaging] disconnect];
     FIRMessaging.messaging.shouldEstablishDirectChannel=false;
    NSLog(@"Disconnected from FCM");
}
// [END disconnect_from_fcm]


-(void)setApplicationApperance
{
    [[UINavigationBar appearance] setTintColor:[UIColor colorFromHexString:@"00aeef"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorFromHexString:@"00aeef"]}];
    
}

#pragma mark - Singlton class instance
+(AppDelegate*)sharedAppdelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}




//[UIColor colorFromHexString:@"049BE5"];
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
