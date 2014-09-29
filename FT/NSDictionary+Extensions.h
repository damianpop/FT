//
//  NSDictionary+Extensions.h
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QueryString)

- (NSString*) queryStringValue;
- (NSString*) queryStringValueAlphabeticalOrder;

@end