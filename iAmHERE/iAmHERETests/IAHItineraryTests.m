//
//  IAHItineraryTests.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 27/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHItinerary.h"
#import "IAHPersistenceManager.h"
#import "IAHPlace.h"

@import XCTest;

@interface IAHItineraryTests : XCTestCase

@property (nonatomic, strong) IAHItinerary *itinerary;
@property (nonatomic, strong) NSArray *placeArr;

@end

@implementation IAHItineraryTests

- (void)setUp {
	[super setUp];
	self.itinerary = [IAHPersistenceManager createObjectWithType:[IAHItinerary class]];
	NSDictionary *tempDic = @{ @"leg" : @[
									   @{ @"maneuver" : @[ @{
															   @"position" : @{ @"latitude" : @0.0,
																				@"longitude" : @0.0 },
															   @"identifier" : @"1"
															   },
														   @{
															   @"position" : @{ @"latitude" : @0.0,
																				@"longitude" : @0.0 },
															   @"identifier" : @"2"
															   },
														   @{
															   @"position" : @{ @"latitude" : @0.0,
																				@"longitude" : @0.0 },
															   @"identifier" : @"3"
															   }
														   ] } ] };
	[self.itinerary deserializeWithDic:tempDic];
	NSMutableArray *placeArr = [NSMutableArray new];
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *placeDic = @{ @"id" : @" ",
								@"position" : @[ @0.000, @0.000 ],
								@"idx" : @0 };
	[place deserializeWithDic:placeDic];
	[placeArr addObject:place];
	place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	placeDic = @{ @"id" : @" ",
				  @"position" : @[ @0.000, @0.000 ],
				  @"idx" : @1 };
	[place deserializeWithDic:placeDic];
	[placeArr addObject:place];
	[self.itinerary addPlaces:[NSSet setWithArray:placeArr]];
	self.placeArr = placeArr;
	[IAHPersistenceManager saveContext:^(NSError *error) {
		XCTAssertNil(error, @"error while saving context: %@\n%@", [error localizedDescription], [error userInfo]);
	}];
}

- (void)tearDown {
	[self.placeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[IAHPersistenceManager deleteObject:obj];
	}];
	[IAHPersistenceManager deleteObject:self.itinerary];
	[IAHPersistenceManager saveContext:^(NSError *error) {
		XCTAssertNil(error, @"error while saving context: %@\n%@", [error localizedDescription], [error userInfo]);
	}];
	[super tearDown];
}

- (void)testPlaces {
	NSArray *sortedPlaces = [self.itinerary sortedPlaces];
	XCTAssertNotNil(sortedPlaces, @"empty places returned!");
}

- (void)testLegs {
	NSArray *sortedLegs = [self.itinerary sortedLegs];
	XCTAssertNotNil(sortedLegs, @"empty legs returned!");
}

- (void)testSortedPlaces {
	NSArray *sortedPlaces = [self.itinerary sortedPlaces];
	XCTAssertTrue([self.placeArr isEqualToArray:sortedPlaces], @"places are not sorted properly!");
}

- (void)testTotalManeuverCount {
	NSUInteger totalCount = [self.itinerary numberOfManeuvers];
	NSSet *maneuvers = [self.itinerary.legs valueForKeyPath:@"@distinctUnionOfSets.maneuvers"];
	XCTAssertEqual(totalCount, maneuvers.count, @"invalid maneuver count!");
}

@end
