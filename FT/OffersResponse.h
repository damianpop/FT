//
//  OffersResponse.h
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OffersResponse : NSObject

@property NSMutableArray* offers;
@property int pagesRemaining;
@property int appId;
@property NSString* apiKey;
@property NSString* userId;
@property NSString* locale;
@property NSString* ip;
@property int offerTypes;

- (id) init;
- (void) addOffers:(NSDictionary*) data;

- (void)loadOffersUserID:(NSString*) userId apiKey:(NSString*)apiKey locale:(NSString*)locale ip:(NSString*)ip
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure;
- (void) loadNextPageSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
