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

@interface IAHRouteManager ()

@property (nonatomic, strong) IAHItinerary *itinerary;

+ (instancetype)sharedManager;

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

@end
