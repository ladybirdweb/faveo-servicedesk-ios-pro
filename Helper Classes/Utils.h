//
//  Utils.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 22/05/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(BOOL)validateUrl:(NSString *)url;
+(BOOL)userNameValidation:(NSString *)strUsername;
+(BOOL)emailValidation:(NSString *)strEmail;
+(BOOL)phoneNovalidation:(NSString *)strPhonr;



+(BOOL)isEmpty:(NSString *)str;

-(void)viewSlideInFromRightToLeft:(UIView *)views;
-(void)viewSlideInFromLeftToRight:(UIView *)views;
-(void)viewSlideInFromTopToBottom:(UIView *)views;
-(void)viewSlideInFromBottomToTop:(UIView *)views;

-(void)showAlertWithMessage:(NSString*)message sendViewController:(UIViewController *)viewController;

-(BOOL)compareDates:(NSString*)date1;
-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate;
-(NSString *)getLocalDateTimeFromUTCDueDate:(NSString *)strDate;



@end
