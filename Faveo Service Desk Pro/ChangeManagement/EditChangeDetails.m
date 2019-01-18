//
//  EditChangeDetails.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 18/01/19.
//  Copyright © 2019 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "EditChangeDetails.h"
#import "SVProgressHUD.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "Reachability.h"
#import "GlobalVariables.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "Utils.h"
#import "ActionSheetStringPicker.h"
#import "ChangeList.h"
#import "ProblemDetailView.h"
#import "ProblemList.h"
#import "SampleNavigation.h"

@interface EditChangeDetails ()<RMessageProtocol,UITextFieldDelegate,UITextViewDelegate>

{
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    NSNumber *requester_id;
    NSNumber *impact_id;
    NSNumber *status_id;
    NSNumber *location_id;
    NSNumber *priority_id;
    NSNumber *changeType_id;
    NSNumber *asset_id;
    
    NSMutableArray * requester_idArray;
    NSMutableArray * impact_idArray;
    NSMutableArray * status_idArray;
    NSMutableArray * location_idArray;
    NSMutableArray * priority_idArray;
    NSMutableArray * changeType_idArray;
    NSMutableArray * asset_idArray;
    
    NSString * descriptionData;
    NSString * subjectData;
    
    NSString * assetIds;
    
}

- (void)requesterWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)statusWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)changeTypeWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)impactWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)locationWasSelected:(NSNumber *)selectedIndex element:(id)element;
//- (void)assetWasSelected:(NSNumber *)selectedIndex element:(id)element;

- (void)actionPickerCancelled:(id)sender;


@end

@implementation EditChangeDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    utils=[[Utils alloc]init];
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalVariables=[GlobalVariables sharedInstance];
    
    _requesterArray=[[NSMutableArray alloc]init];
    _impactTypeArray=[[NSMutableArray alloc]init];
    _statusArray=[[NSMutableArray alloc]init];
    _locationArray=[[NSMutableArray alloc]init];
    _priorityArray=[[NSMutableArray alloc]init];
    _changeTypeArray=[[NSMutableArray alloc]init];
    _assetArray=[[NSMutableArray alloc]init];
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD showWithStatus:@"Please wait"];
    [self reload];
    
    self.sampleTableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getMetaDataForChange];
}




- (IBAction)requesterTextFieldTouched:(id)sender {
    
    @try{
        [self.view endEditing:YES];
        if (!_requesterArray||!_requesterArray.count) {
            _requesterTextField.text=NSLocalizedString(@"Not Available",nil);
            requester_id=0;
        }else{
            [ActionSheetStringPicker showPickerWithTitle:@"Select Requester" rows:_requesterArray initialSelection:0 target:self successAction:@selector(requesterWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
    }@catch (NSException *exception)
    {
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        [utils showAlertWithMessage:exception.name sendViewController:self];
        return;
    }
    @finally
    {
        NSLog( @" I am in requesterTextFieldClicked method in Edit Change VC" );
        
    }
    
}

- (IBAction)impactTextFieldTouched:(id)sender {
}

- (IBAction)statusTextFieldTouched:(id)sender {
}

- (IBAction)priorityTextFieldTouched:(id)sender {
}

- (IBAction)changeTypeTextFieldTouched:(id)sender {
}

- (IBAction)locationTextFieldTouched:(id)sender {
}
@end
