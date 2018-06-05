//
//  MyWebservices.h
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 05/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkResponce)(id responce);
typedef void (^callbackHandler) (NSError *, id,NSString*);
typedef void (^routebackHandler) (NSError *, id, NSHTTPURLResponse*);
typedef void (^ApiResponse)(NSError* , id);

@interface MyWebservices : NSObject

@property(nonatomic,strong)NSURLSession *session;

+ (instancetype)sharedInstance;

-(NSString*)refreshToken;

-(void)httpResponseGET:(NSString *)urlString
             parameter:(id)parameter
       callbackHandler:(callbackHandler)block;

-(void)httpResponsePOST:(NSString *)urlString
              parameter:(id)parameter
        callbackHandler:(callbackHandler)block;


-(void)getNextPageURL:(NSString*)url callbackHandler:(callbackHandler)block;

-(void)getNextPageURL:(NSString*)url user_id:(NSString*)uid callbackHandler:(callbackHandler)block;

-(void)getNextPageURLInbox:(NSString*)url pageNo:(NSString*)pageInt callbackHandler:(callbackHandler)block;

-(void)getNextPageURLInboxSearchResults:(NSString*)url searchString:(NSString*)searchData pageNo:(NSString*)pageInt callbackHandler:(callbackHandler)block;

-(void)getNextPageURLUnassigned:(NSString*)url pageNo:(NSString*)pageInt callbackHandler:(callbackHandler)block;

-(void)getNextPageURLMyTickets:(NSString*)url pageNo:(NSString*)pageInt callbackHandler:(callbackHandler)block;

-(void)getNextPageURLClosed:(NSString*)url pageNo:(NSString*)pageInt callbackHandler:(callbackHandler)block;

-(void)getNextPageURLTrash:(NSString*)url pageNo:(NSString*)pageInt callbackHandler:(callbackHandler)block;

-(void)callPATCHAPIWithAPIName:(NSString *)urlString
                     parameter:(id)parameter
               callbackHandler:(callbackHandler)block;

-(void)getNextPageUSERFilter:(NSString*)url  callbackHandler:(callbackHandler)block;



@end
