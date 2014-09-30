//
//  FTTests.m
//  FTTests
//
//  Created by Damian Troncoso on 9/28/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OffersLoader.h"
#import "AGAsyncTestHelper.h"

@interface FTTests : XCTestCase

@property OffersLoader* offersLoader;

@end

@implementation FTTests

- (void)setUp {
    [super setUp];

    self.offersLoader = [[OffersLoader alloc] init];
}

- (void)tearDown {
    [super tearDown];
    self.offersLoader = nil;
}

- (void)testGoodRequest {
    __block BOOL finished = NO;
    [self.offersLoader loadOffersUserID:@"spiderman" apiKey:@"1c915e3b5d42d05136185030892fbb846c278927" locale:@"DE" ip:@"109.235.143.113" success:^{
        XCTAssert(YES, "Success");
        finished = true;
    } failure:^(NSError *error) {
        XCTAssert(NO, "Fail");
        finished = true;
    }];
    AGWW_WAIT_WHILE(!finished, 10.0); // wait for 10 seconds
    XCTAssert(finished, @"Timeout error"); // if in 10 seconds there's no server response, fail
}

- (void)testEmptyRequest {
    __block BOOL finished = NO;
    [self.offersLoader loadOffersUserID:@"spiderman" apiKey:@"1c915e3b5d42d05136185030892fbb846c278927" locale:@"DE" ip:@"1.1.1.1" success:^{
        XCTAssert(self.offersLoader.offers.count == 0, "Success");
        finished = true;
    } failure:^(NSError *error) {
        XCTAssert(NO, "Fail");
        finished = true;
    }];
    AGWW_WAIT_WHILE(!finished, 10.0); // wait for 10 seconds
    XCTAssert(finished, @"Timeout error"); // if in 10 seconds there's no server response, fail
}

- (void)testInvalidApiKey {
    __block BOOL finished = NO;
    [self.offersLoader loadOffersUserID:@"spiderman" apiKey:@"1c915e3b5d42d05136185030892fbb846c27892-" locale:@"DE" ip:@"1.1.1.1" success:^{
        XCTAssert(self.offersLoader.offers.count == 0, "Success");
        finished = true;
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, 401, "Expected Unauthorized error");
        finished = true;
    }];
    AGWW_WAIT_WHILE(!finished, 10.0); // wait for 10 seconds
    XCTAssert(finished, @"Timeout error"); // if in 10 seconds there's no server response, fail
}

- (void)testInvalidRequest {
    __block BOOL finished = NO;
    [self.offersLoader loadOffersUserID:@"" apiKey:@"" locale:@"" ip:@"" success:^{
        XCTAssert(self.offersLoader.offers.count == 0, "Success");
        finished = true;
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, 400, "Expected Invalid request error");
        finished = true;
    }];
    AGWW_WAIT_WHILE(!finished, 10.0); // wait for 10 seconds
    XCTAssert(finished, @"Timeout error"); // if in 10 seconds there's no server response, fail
}

@end
