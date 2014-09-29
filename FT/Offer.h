//
//  Offer.h
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject

@property NSString* title;
@property NSString* teaser;
@property NSString* thumbnailUrl;
@property int payout;

+ (Offer*) offerWithData:(NSDictionary*) data;
- (id) initWithData:(NSDictionary*) data;

@end
