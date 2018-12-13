//
//  EditChangeDetails.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 04/12/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditChangeDetails : UITableViewController


@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UITextField *requesterTextField;
@property (weak, nonatomic) IBOutlet UITextField *impactTextField;
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

@property (weak, nonatomic) IBOutlet UITextField *changeTypeTextField;

@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

//@property (weak, nonatomic) IBOutlet UITextField *assetTextField;



- (IBAction)requesterTextFieldTouched:(id)sender;

- (IBAction)impactTypeTextFieldClicked:(id)sender;

- (IBAction)statusTextFieldTouched:(id)sender;

- (IBAction)priorityTextFieldTouched:(id)sender;

- (IBAction)changeTypeTextFieldTouched:(id)sender;

- (IBAction)locationTextFieldTouched:(id)sender;

//- (IBAction)assetTextFieldTouched:(id)sender;


- (IBAction)updateButtonClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *updateButtonOutlet;


/*!
 @property fromArray
 
 @brief This is array that represents list of owner/creater of the change with basic details.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * requesterArray;

/*!
 @property statusArray
 
 @brief This is array that represents list of ticket types present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * statusArray;

/*!
 @property priorityArray
 
 @brief This is array that represents list of different priority types present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * priorityArray;


/*!
 @property changeTypeArray
 
 @brief This is array that represents list of different change types present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * changeTypeArray;


/*!
 @property impactTypeArray
 
 @brief This is array that represents list of different impact types present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * impactTypeArray;


/*!
 @property locationArray
 
 @brief This is array that represents list of different locations present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * locationArray;

/*!
 @property assetArray
 
 @brief This is array that represents list of asset names with its id which are present in the Helpdesk
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSMutableArray * assetArray;


@end

