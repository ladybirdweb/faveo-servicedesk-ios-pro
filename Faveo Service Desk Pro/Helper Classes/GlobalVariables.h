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
//ticketId NSNumber
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


//Add requester
@property (strong, nonatomic) NSString *emailFromAddRequester;
@property (strong, nonatomic) NSString *firstNameFromAddRequester;
@property (strong, nonatomic) NSString *lastNameFromAddRequester;
@property (strong, nonatomic) NSString *mobileNubmberFromAddRequster;
@property (strong, nonatomic) NSString *mobileCodeFromAddRequester;


@property (strong, nonatomic) NSMutableArray *assigneeIdArrayListToTicketCreate;
@property (strong, nonatomic) NSMutableArray *attachArrayFromConversation;

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


// cc
@property (strong, nonatomic) NSString *ccCount;
@property (strong, nonatomic) NSArray *collaboratorListArray;
@property (strong, nonatomic) NSArray *ccListArray1;


// used to save data from dependency API
@property (strong, nonatomic) NSDictionary *dependencyDataDict;


//Assign

@property (strong, nonatomic) NSString *backButtonActionFromMergeViewMenu;
@property (strong, nonatomic) NSString *ticketIDListForAssign;


// merge

@property (strong, nonatomic) NSMutableArray *idList;
@property (strong, nonatomic) NSMutableArray *subjectList;


//problem
@property (strong, nonatomic) NSNumber *problemId;


// priority color
@property (strong, nonatomic) NSString *priorityColorLowForProblemsList;
@property (strong, nonatomic) NSString *priorityColorNormalProblemsList;
@property (strong, nonatomic) NSString *priorityColorHighProblemsList;
@property (strong, nonatomic) NSString *priorityColorEmergencyProblemsList;

@property (strong, nonatomic) NSMutableArray *asstArray;
@property (strong, nonatomic) NSMutableArray *ticketArray;


@property (strong, nonatomic) NSString *createProblemConditionforVC;
@property (strong, nonatomic) NSString *ticketIdForTicketDetail;

//Used in Ticket Details VC
@property (strong, nonatomic) NSString *problemStatusInTicketDetailVC;
@property (strong, nonatomic) NSString *assetStatusInTicketDetailVC;

//Used in Problem Details VC
@property (strong, nonatomic) NSString *ticketStatusInProblemDetailVC;
@property (strong, nonatomic) NSString *assetStatusInProblemDetailVC;


//attached problem dictionary
@property (strong, nonatomic) NSDictionary *attachedProblemDataDict;

//show left navigation item/button in problem detail after navigating problem pop-up in ticket detail
@property (strong, nonatomic) NSString *showNavigationItem; //show//hide

@property (strong, nonatomic) NSArray * attachedAssetList;

@property (strong, nonatomic) NSNumber *problemId2;

// This variable stores values of RootCause, Impact, Symptoms and Solution
@property (strong, nonatomic) NSString *rootCuaseValue;
@property (strong, nonatomic) NSString *impactValue;
@property (strong, nonatomic) NSString *symptomsValue;
@property (strong, nonatomic) NSString *solutionValue;

//This property is used to identify that which button clicked on update modalView for a problem. Values can be rootCause, impact, symptoms and solution.
@property (strong, nonatomic) NSString *updateProblemValue;


//used this condition while creating a change
@property (strong, nonatomic) NSString *createChangeConditionforVC;

//change id passing to chnage list to change details
@property (strong, nonatomic) NSString *changeId;

// This variable stores values of Reason, Impact, Roll-out and Back-out plan
@property (strong, nonatomic) NSString *reasonForChangeValue;
@property (strong, nonatomic) NSString *impactValueForChange;
@property (strong, nonatomic) NSString *rollOutValueForChange;
@property (strong, nonatomic) NSString *backOutValueForChange;


//This property is used to identify that which button clicked on update modalView for a change. Values can be reason, impact, rollout and backout plan.
@property (strong, nonatomic) NSString *updateChangeValue;


// used this condition while creating/adding a change
@property (strong, nonatomic) NSString *changeStatusInTicketDetailVC;

//attached change dictionary
@property (strong, nonatomic) NSDictionary *attachedChangeDataDict;

//attached assets array asssociated with the change
@property (strong, nonatomic) NSArray *associatedAssetsWithTheChangeArray;

//it used to check wheather asset is present or not in change details
@property (strong, nonatomic) NSString *assetStatusInChangeDetailVC;



//Release id
@property (strong, nonatomic) NSString *releaseId;

//It used to to check wheather this release is creating fresh or with the problem.
@property (strong, nonatomic) NSString *createReleaseConditionforVC;
@end
