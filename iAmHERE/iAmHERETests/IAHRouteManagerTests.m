//
//  IAHRouteManagerTests.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 27/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHRouteManager.h"
#import "IAHPersistenceManager.h"
#import "IAHPlace.h"

@import XCTest;

@interface IAHRouteManagerTests : XCTestCase

@property (nonatomic, strong) IAHItinerary *itinerary;
@property (nonatomic, strong) NSArray *placeArr;

@end

@implementation IAHRouteManagerTests

- (void)setUp {
    [super setUp];
	self.itinerary = [IAHRouteManager sharedManager].itinerary;
	NSMutableArray *placeArr = [NSMutableArray new];
	IAHPlace *place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	NSDictionary *placeDic = @{ @"id" : @" ",
								@"position" : @[ @0.000, @0.000 ] };
	[place deserializeWithDic:placeDic];
	[placeArr addObject:place];
	[[IAHRouteManager sharedManager] addPlace:place];
	place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
	placeDic = @{ @"id" : @" ",
				  @"position" : @[ @0.000, @0.000 ] };
	[place deserializeWithDic:placeDic];
	[placeArr addObject:place];
	[[IAHRouteManager sharedManager] addPlace:place];
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

- (void)testPlaceIndexing {
	XCTAssertEqual([self.placeArr firstObject], [[self.itinerary sortedPlaces] firstObject], @"invalid place sorting");
	XCTAssertEqual([self.placeArr lastObject], [[self.itinerary sortedPlaces] lastObject], @"invalid place sorting");
}

- (void)testPlaceChange {
	[[IAHRouteManager sharedManager] exchangePlace:[self.placeArr firstObject] withPlace:[self.placeArr lastObject]];
	XCTAssertNotEqual([self.placeArr firstObject], [[self.itinerary sortedPlaces] firstObject], @"invalid place sorting");
	XCTAssertNotEqual([self.placeArr lastObject], [[self.itinerary sortedPlaces] lastObject], @"invalid place sorting");
	XCTAssertEqual([self.placeArr lastObject], [[self.itinerary sortedPlaces] firstObject], @"invalid place sorting");
	XCTAssertEqual([self.placeArr firstObject], [[self.itinerary sortedPlaces] lastObject], @"invalid place sorting");
}

@end
