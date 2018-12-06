//
//  Card.h
//  UnitTestsCardExample
//
//  Created by Stephan B Wessels on 1/23/14.
//  Copyright (c) 2014 Plum Street Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
