//
//  IAHPlaceTests.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHPersistenceManager.h"
#import "IAHPlace.h"

@import XCTest;

@interface IAHPlaceTests : XCTestCase

@end

@implementation IAHPlaceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPlaceHrefURLSuccess {
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *tempDic = @{ @"href" : @"http://example.com" };
	[place deserializeWithDic:tempDic];
	XCTAssertNotNil(place.hrefURL, @"nil URL returned");
}

- (void)testPlaceHrefURLFailure {
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *tempDic = @{ @"href" : @" " };
	[place deserializeWithDic:tempDic];
	XCTAssertNil(place.hrefURL, @"non-nil URL returned");
}

- (void)testPlaceIconURLSuccess {
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *tempDic = @{ @"icon" : @"http://example.com" };
	[place deserializeWithDic:tempDic];
	XCTAssertNotNil(place.iconURL, @"nil URL returned");
}

- (void)testPlaceIconURLFailure {
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *tempDic = @{ @"icon" : @" " };
	[place deserializeWithDic:tempDic];
	XCTAssertNil(place.iconURL, @"non-nil URL returned");
}

- (void)testPlaceLocationSuccess {
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *tempDic = @{ @"position" : @[ @0.0000, @0.0000 ] };
	[place deserializeWithDic:tempDic];
	XCTAssertNotNil(place.location, @"nil location returned");
}

- (void)testPlaceLocationFailure {
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *tempDic = @{ @"position" : @[] };
	[place deserializeWithDic:tempDic];
	XCTAssertNil(place.location, @"non-nil location returned");
}

@end
