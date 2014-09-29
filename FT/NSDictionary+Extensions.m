//
//  NSDictionary+Extensions.m
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import "NSDictionary+Extensions.h"
#import "NSString+Extensions.h"

@implementation NSDictionary (QueryString)

- (NSString *)queryStringValue
{
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [self keyEnumerator])
    {
        id value = [self objectForKey:key];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

- (NSString *)queryStringValueAlphabeticalOrder
{
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [self keyEnumerator])
    {
        id value = [self objectForKey:key];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    NSArray* orderedPairs = [pairs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString*)obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    return [orderedPairs componentsJoinedByString:@"&"];
}

@end
