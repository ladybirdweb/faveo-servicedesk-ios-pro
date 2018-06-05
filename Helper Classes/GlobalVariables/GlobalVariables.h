//
//  GlobalVariables.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVariables : NSObject


+ (instancetype)sharedInstance;

@property (strong, nonatomic) NSString *urlDemo;
@property (strong, nonatomic) NSString *roleFromAuthenticateAPI;

@end
