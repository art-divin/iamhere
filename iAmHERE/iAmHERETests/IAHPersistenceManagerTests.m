//
//  IAHPersistenceManagerTests.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHPlace.h"
#import "IAHPersistenceManager.h"

@import XCTest;

@interface IAHPersistenceManagerTests : XCTestCase

@property (nonatomic, strong) IAHPlace *place;

@end

@implementation IAHPersistenceManagerTests

- (void)setUp {
	[super setUp];
	self.place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *tempDic = @{ @"id" : @" ", @"position" : @[ @0.000, @0.000 ] };
	[self.place deserializeWithDic:tempDic];
	[IAHPersistenceManager saveContext:^(NSError *error) {
		XCTAssertNil(error, @"error while saving context: %@\n%@", [error localizedDescription], [error userInfo]);
	}];
}

- (void)tearDown {
	[IAHPersistenceManager deleteObject:self.place];
	[IAHPersistenceManager saveContext:^(NSError *error) {
		XCTAssertNil(error, @"error while saving context: %@\n%@", [error localizedDescription], [error userInfo]);
	}];
	[super tearDown];
}

- (void)testCreateObjectFailure {
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	XCTAssertNotNil(place, @"nil object returned");
	XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
	[IAHPersistenceManager saveContext:^(NSError *error) {
		XCTAssertNotNil(error, @"empty error where it shouldn't be");
		[IAHPersistenceManager deleteObject:place];
		[IAHPersistenceManager saveContext:^(NSError *error) {
			XCTAssertNil(error, @"error while saving context: %@\n%@", [error localizedDescription], [error userInfo]);
			[expectation fulfill];
		}];
	}];
	[self waitForExpectationsWithTimeout:30.0f handler:^(NSError *error) {
		XCTAssertNil(error, @"error while executing test: %@: %@\n%@", NSStringFromSelector(_cmd),
					 [error localizedDescription],
					 [error userInfo]);
	}];
}

- (void)testCreateObjectSuccess {
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *tempDic = @{ @"id" : @" ", @"position" : @[ @0.000, @0.000 ] };
	[place deserializeWithDic:tempDic];
	XCTAssertNotNil(place, @"nil object returned");
	XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
	[IAHPersistenceManager saveContext:^(NSError *error) {
		XCTAssertNil(error, @"error while saving context: %@\n%@", [error localizedDescription], [error userInfo]);
		[IAHPersistenceManager deleteObject:place];
		[IAHPersistenceManager saveContext:^(NSError *error) {
			XCTAssertNil(error, @"error while saving context: %@\n%@", [error localizedDescription], [error userInfo]);
			[expectation fulfill];
		}];
	}];
	[self waitForExpectationsWithTimeout:30.0f handler:^(NSError *error) {
		XCTAssertNil(error, @"error while executing test: %@: %@\n%@", NSStringFromSelector(_cmd),
					 [error localizedDescription],
					 [error userInfo]);
	}];
}

- (void)testFetchObjectNoPredicate {
	IAHPlace *place = [IAHPersistenceManager objectWithType:[IAHPlace class]
												  predicate:nil
												  arguments:nil];
	XCTAssertNotNil(place, @"nil place returned where it shouldn't be");
	XCTAssertTrue(place == self.place, @"invalid place returned");
}

- (void)testFetchObjectWithPredicate {
	IAHPlace *place = [IAHPersistenceManager objectWithType:[IAHPlace class]
												  predicate:@"self.identifier == %@"
												  arguments:@[ @" " ]];
	XCTAssertNotNil(place, @"nil place returned where it shouldn't be");
	XCTAssertTrue(place == self.place, @"invalid place returned");
}

- (void)testFetchObjectsNoPredicate {
	NSArray *placeArr = [IAHPersistenceManager objectsWithType:[IAHPlace class]
													 predicate:nil
													 arguments:nil
											   sortDescriptors:nil];
	XCTAssertNotNil(placeArr, @"empty array returned!");
	XCTAssertTrue(placeArr.count == 1, @"invalid number of places returned");
	XCTAssertTrue([placeArr containsObject:self.place], @"invalid place returned");
}

- (void)testFetchObjectsWithPredicate {
	NSArray *placeArr = [IAHPersistenceManager objectsWithType:[IAHPlace class]
													 predicate:@"self.identifier == %@"
													 arguments:@[ @" " ]
											   sortDescriptors:nil];
	XCTAssertNotNil(placeArr, @"empty array returned!");
	XCTAssertTrue(placeArr.count == 1, @"invalid number of places returned");
	XCTAssertTrue([placeArr containsObject:self.place], @"invalid place returned");
}

- (void)testFetchObjectSuccess {
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *tempDic = @{ @"id" : @" ", @"position" : @[ @0.000, @0.000 ] };
	[place deserializeWithDic:tempDic];
	XCTAssertNotNil(place, @"nil object returned");
	XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
	[IAHPersistenceManager saveContext:^(NSError *error) {
		XCTAssertNil(error, @"error while saving context: %@\n%@", [error localizedDescription], [error userInfo]);
		[IAHPersistenceManager deleteObject:place];
		[IAHPersistenceManager saveContext:^(NSError *error) {
			XCTAssertNil(error, @"error while saving context: %@\n%@", [error localizedDescription], [error userInfo]);
			[expectation fulfill];
		}];
	}];
	[self waitForExpectationsWithTimeout:30.0f handler:^(NSError *error) {
		XCTAssertNil(error, @"error while executing test: %@: %@\n%@", NSStringFromSelector(_cmd),
					 [error localizedDescription],
					 [error userInfo]);
	}];
}

@end
