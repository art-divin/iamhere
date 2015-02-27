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
#import "IAHRESTManager.h"

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

- (void)calculateRoute:(void (^)(IAHItinerary *, NSError *))callback {
	NSArray *locationArr = [self.itinerary valueForKeyPath:@"sortedPlaces.location"];
	__weak typeof(self) weakSelf = self;
	[IAHRESTManager fetchRouteForLocations:locationArr
							 transportType:@"car"
						   completionBlock:
	 ^(NSArray *routeArr, XTResponseError *error) {
		 if (!error) {
			 if (routeArr.count > 0) {
				 // TODO: consider more than 1 route
				 [weakSelf.itinerary deserializeWithDic:[routeArr firstObject]];
				 [weakSelf saveWithCallback:^(NSError *error) {
					 callback(weakSelf.itinerary, error);
				 }];
			 }
		 } else {
			 // TODO: show error
			 callback(nil, error);
		 }
	 }];
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
