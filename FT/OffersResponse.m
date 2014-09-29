//
//  OffersResponse.m
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import "OffersResponse.h"
#import "Offer.h"

@implementation OffersResponse

+ (OffersResponse*) responseWithData:(NSDictionary*) data {
    OffersResponse* res = [[OffersResponse alloc] initWithData:data];
    return res;
}

- (id) initWithData:(NSDictionary*) data {
    self = [super init];
    
    self.offers = [[NSMutableArray alloc] init];
    
    NSArray* offersData = [data objectForKey:@"offers"];
    for(NSDictionary* offerData in offersData){
        Offer* offer = [Offer offerWithData:offerData];
        [self.offers addObject:offer];
    }
    
    return self;
}

@end
