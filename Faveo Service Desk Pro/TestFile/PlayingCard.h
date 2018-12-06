//
//  PlayingCard.h
//  UnitTestsCardExample
//
//  Created by Stephan B Wessels on 1/23/14.
//  Copyright (c) 2014 Plum Street Software. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
