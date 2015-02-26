//
//  IAHRouteManager.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHRouteManager.h"
#import "IAHPersistenceManager.h"
#import "IAHItinerary.h"
#import "IAHPlace.h"

@interface IAHRouteManager ()

@end

@implementation IAHRouteManager

- (instancetype)init {
	self = [super init];
	if (self) {
		_itinerary = [IAHPersistenceManager objectWithType:[IAHItinerary class]
												 predicate:nil
												 arguments:nil];
		if (!_itinerary) {
			_itinerary = [IAHPersistenceManager createObjectWithType:[IAHItinerary class]];
			[IAHPersistenceManager saveContext:^(NSError *error) {
				// TODO: handle errors
			}];
		}
	}
	return self;
}

+ (instancetype)sharedManager {
	static IAHRouteManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [IAHRouteManager new];
	});
	return instance;
}

- (void)addPlace:(IAHPlace *)place {
	place.idx = @(self.itinerary.places.count);
	[self.itinerary addPlacesObject:place];
}

- (void)removePlace:(IAHPlace *)place {
	[self.itinerary removePlacesObject:place];
}

- (void)exchangePlace:(IAHPlace *)place withPlace:(IAHPlace *)withPlace {
	NSNumber *idx = place.idx;
	place.idx = withPlace.idx;
	withPlace.idx = idx;
}

- (void)saveWithCallback:(void (^)(NSError *))callback {
	[IAHPersistenceManager saveContext:^(NSError *error) {
		// TODO: handle errors
		if (callback) {
			callback(error);
		}
	}];
}

@end
