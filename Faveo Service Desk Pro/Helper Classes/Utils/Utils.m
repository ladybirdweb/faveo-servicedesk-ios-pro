//
//  Utils.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 22/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "Utils.h"
#import "AppConstanst.h"
#import "NSDate+NVTimeAgo.h"


@implementation Utils


+ (BOOL)validateUrl: (NSString *) url {
    
    
    NSURL* urls = [NSURL URLWithString:url];
    if (urls == nil && ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"] )) {
        
        NSLog(@"Nope %@ is not a proper URL", url);
        return NO;
    }
    return YES;
}

+(BOOL)userNameValidation:(NSString *)strUsername;
{
    if(strUsername.length >= 5){
        
        return YES;
    }
    
    return NO;
}

+(BOOL)emailValidation:(NSString *)strEmail;
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:strEmail];
    
    return myStringMatchesRegEx;
}

+(BOOL)phoneNovalidation:(NSString *)strPhone;
{
    NSString *phoneRegex = @"^[+(00)][0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL phoneValidates = [phoneTest evaluateWithObject:strPhone];
    
    return phoneValidates;
}


+(BOOL)isEmpty:(NSString *)str{
    if (str == nil || str == (id)[NSNull null] || [[NSString stringWithFormat:@"%@",str] length] == 0 || [[[NSString stringWithFormat:@"%@",str] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        
        return YES;
    }
    return NO;
}



-(void)viewSlideInFromRightToLeft:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    // transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
    
}

-(void)viewSlideInFromLeftToRight:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    //transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

-(void)viewSlideInFromTopToBottom:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromBottom ;
    //transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

-(void)viewSlideInFromBottomToTop:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromTop ;
    // transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

-(void)showAlertWithMessage:(NSString*)message sendViewController:(UIViewController *)viewController
{
    UIAlertController *alertController = [UIAlertController   alertControllerWithTitle:APP_NAME message:message  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction  actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    [alertController addAction:cancelAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}


-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate
{
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dtFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *aDate = [dtFormat dateFromString:strDate];
    
    [dtFormat setDateFormat:@"d MMM yyyy HH:mm"];
    [dtFormat setTimeZone:[NSTimeZone systemTimeZone]];
    NSString * fg=[dtFormat stringFromDate:aDate];
    
    
    //    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    //   return [timeIntervalFormatter stringForTimeIntervalFromDate:aDate toDate:[NSDate date]];
    
    return [[dtFormat dateFromString:fg] formattedAsTimeAgo];
    
}

-(NSString *)getLocalDateTimeFromUTCDueDate:(NSString *)strDate
{
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dtFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *aDate = [dtFormat dateFromString:strDate];
    
    [dtFormat setDateFormat:@"d MMM yyyy HH:mm"];
    [dtFormat setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *fg=[dtFormat stringFromDate:aDate];
    
    return fg;
    
    
}

-(BOOL)compareDates:(NSString*)strDate{
    
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dtFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date1 = [dtFormat dateFromString:strDate];
    
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date2=[dateFormatter dateFromString:[dateFormatter stringFromDate:todayDate]];
    
    if ([date1 compare:date2] == NSOrderedDescending) {
        NSLog(@"date1 is later than date2");
        return NO;
        
    } else if ([date1 compare:date2] == NSOrderedAscending) {
        NSLog(@"date1 is earlier than date2");
        return YES;
        
    } else {
        NSLog(@"dates are the same");
        return NO;
        
    }
    
}



@end
