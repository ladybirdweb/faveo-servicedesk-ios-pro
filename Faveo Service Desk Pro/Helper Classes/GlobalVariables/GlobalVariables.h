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

@property (strong, nonatomic) NSString *urlDemo;   //userFilterId
@property (strong, nonatomic) NSString *roleFromAuthenticateAPI;


// ticket information

@property (strong, nonatomic) NSNumber *ticketId;
@property (strong, nonatomic) NSString *ticketStatus;
@property (strong, nonatomic) NSString *ticketNumber;
@property (strong, nonatomic) NSString *ticketStatusBool;
@property (strong, nonatomic) NSString *firstNameFromTicket;
@property (strong, nonatomic) NSString *lastNameFromTicket;
@property (strong, nonatomic) NSString *userIdFromTicket;


//user for user filter option at user list
@property (strong, nonatomic) NSString *userFilterId;

@property (strong, nonatomic) NSString *userIDFromUserList;
@property (strong, nonatomic) NSString *userNameFromUserList;
@property (strong, nonatomic) NSString *First_nameFromUserList;
@property (strong, nonatomic) NSString *Last_nameFromUserList;
@property (strong, nonatomic) NSString *emailFromUserList;
@property (strong, nonatomic) NSString *phoneNumberFromUserList;
@property (strong, nonatomic) NSString *mobileNumberFromUserList;
@property (strong, nonatomic) NSString *userStateFromUserList;
@property (strong, nonatomic) NSString *mobilecodeFromUserList;

@property (strong, nonatomic) NSString *customerFromView;
@property (strong, nonatomic) NSString *userImageFromUserList;
@property (strong, nonatomic) NSString *userRoleFromUserList;
@property (strong, nonatomic) NSString *ActiveDeactiveStateOfUser1;

@property (strong, nonatomic) NSString *nameInCilent;



// ticket counts

@property (strong, nonatomic) NSString *OpenCount;
@property (strong, nonatomic) NSString *ClosedCount;
@property (strong, nonatomic) NSString *DeletedCount;
@property (strong, nonatomic) NSString *UnassignedCount;
@property (strong, nonatomic) NSString *MyticketsCount;
@property (strong, nonatomic) NSString *UnaprovedCount;


// filter and sorting

@property (strong, nonatomic) NSString *filterId;
@property (strong, nonatomic) NSString *sortCondition;
@property (strong, nonatomic) NSString *sortCondtionValueToSendWebServices;


@property (strong, nonatomic) NSMutableArray *attachArrayFromConversation;


@end
