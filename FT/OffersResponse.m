//
//  OffersResponse.m
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import "OffersResponse.h"
#import "Offer.h"
#import "NSDictionary+Extensions.h"
#import "NSString+Extensions.h"
#import "AFNetworking.h"
#import "NSDictionary+Extensions.h"
#import "NSString+Extensions.h"
#import "AFNetworking.h"
#import <AdSupport/AdSupport.h>

@implementation OffersResponse

- (id) init {
    self = [super init];
    self.offers = [[NSMutableArray alloc] init];
    return self;
}

- (void) addOffers:(NSDictionary*) data {
    NSArray* offersData = [data objectForKey:@"offers"];
    for(NSDictionary* offerData in offersData){
        Offer* offer = [Offer offerWithData:offerData];
        [self.offers addObject:offer];
    }
}

- (id) initWithData:(NSDictionary*) data {
    self = [super init];
    
    self.offers = [[NSMutableArray alloc] init];
    self.pagesRemaining = [[data objectForKey:@"pages"] intValue] - 1;
    
    NSArray* offersData = [data objectForKey:@"offers"];
    for(NSDictionary* offerData in offersData){
        Offer* offer = [Offer offerWithData:offerData];
        [self.offers addObject:offer];
    }
    
    return self;
}

- (void) makeRequestPage:(int)page success:(void (^)(NSDictionary* data))success failure:(void (^)(NSError *error))failure{
    NSDictionary *queryParams = @{@"appid" : [NSNumber numberWithInt:self.appId],
                                  @"uid" : self.userId,
                                  @"locale": self.locale,
                                  @"ip" : self.ip,
                                  @"offer_types" : [NSNumber numberWithInt:self.offerTypes],
                                  @"timestamp" : [NSString stringWithFormat:@"%lli",(long long)([[NSDate date] timeIntervalSince1970])] ,
                                  @"device_id" : [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                                  @"page" : [NSNumber numberWithInt:page] };
    
    NSString* queryString = [queryParams queryStringValueAlphabeticalOrder];
    NSString* conc = [NSString stringWithFormat:@"%@&%@", queryString, self.apiKey];
    NSString* hash = [conc sha1];
    
    queryString = [NSString stringWithFormat:@"%@?%@&%@=%@", @"http://api.sponsorpay.com/feed/v1/offers.json", queryString, @"hashkey", hash];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:queryString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* res = (NSDictionary*)responseObject;
        success(res);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)loadOffersUserID:(NSString*) userId apiKey:(NSString*)apiKey locale:(NSString*)locale ip:(NSString*)ip 
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure {
    
    
    
    self.appId = 2070;
    self.userId = userId,
    self.locale = locale;
    self.ip = ip;
    self.offerTypes = 112;
    self.apiKey = apiKey;
    
    [self makeRequestPage:1 success:^(NSDictionary* data) {
        [self addOffers:data];
        self.pagesRemaining = [[data objectForKey:@"pages"] intValue] - 1;
        
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void) loadNextPageSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    if(self.pagesRemaining <= 0) {
        success();
    } else {
        [self makeRequestPage:2 success:^(NSDictionary* data) {
            [self addOffers:[data objectForKey:@"offers"]];
            self.pagesRemaining --;
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

@end
