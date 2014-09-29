//
//  Offer.m
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import "Offer.h"

@implementation Offer

+ (Offer*) offerWithData:(NSDictionary*) data {
    Offer* res = [[Offer alloc] initWithData:data];
    return res;
}

- (id) initWithData:(NSDictionary*) data {
    self = [super init];
    
    self.title = [data objectForKey:@"title"];
    self.teaser = [data objectForKey:@"teaser"];
    self.thumbnailUrl = [[data objectForKey:@"thumbnail"] objectForKey:@"hires"];
    self.payout = [[data objectForKey:@"payout"] intValue];
    
    return self;
}

@end
