//
//  OffersResponse.m
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import "OffersLoader.h"
#import "Offer.h"
#import "NSDictionary+Extensions.h"
#import "NSString+Extensions.h"
#import "AFNetworking.h"
#import "NSDictionary+Extensions.h"
#import "NSString+Extensions.h"
#import "AFNetworking.h"
#import <AdSupport/AdSupport.h>

@implementation OffersLoader

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
        NSString* responseSignature = [[operation.response allHeaderFields] objectForKey:@"X-Sponsorpay-Response-Signature"];
        NSString* response = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        response = [NSString stringWithFormat:@"%@%@", response, self.apiKey];
        NSString* localSignature = [response sha1];
        
        if([localSignature isEqualToString:responseSignature]){
            NSDictionary* res = (NSDictionary*)responseObject;
            success(res);
        } else {
            NSDictionary *details = @{NSLocalizedDescriptionKey : @"Response is invalid"};
            NSError* err = [NSError errorWithDomain:@"err" code:10 userInfo:details];
            failure(err);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *details = @{NSLocalizedDescriptionKey : error.localizedDescription};
        int code = operation.response.statusCode;
        NSError* err = [NSError errorWithDomain:error.domain code:code userInfo:details];
        failure(err);
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
        self.pages = [[data objectForKey:@"pages"] intValue];
        self.pagesLoaded = 1;
        
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void) loadNextPageSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    if(self.pages - self.pagesLoaded <= 0) {
        success();
    } else {
        self.pagesLoaded ++;
        [self makeRequestPage:self.pagesLoaded success:^(NSDictionary* data) {
            [self addOffers:data];
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

@end
