//
//  IAHLocationManager.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHLocationManager.h"

@interface IAHLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) NSMutableArray *subscriptionArr;

/*! private singleton */
+ (instancetype)sharedManager;

@end

@implementation IAHLocationManager

- (instancetype)init {
	self = [super init];
	if (self) {
		__weak typeof(self) weakSelf = self;
		dispatch_async(dispatch_get_main_queue(), ^{
			weakSelf.locManager = [[CLLocationManager alloc] init];
			weakSelf.subscriptionArr = [NSMutableArray new];
			if ([weakSelf.locManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
				[weakSelf.locManager requestWhenInUseAuthorization];
			}
			[weakSelf.locManager startUpdatingLocation];
			weakSelf.locManager.delegate = self;
		});
	}
	return self;
}

+ (instancetype)sharedManager {
	static IAHLocationManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [IAHLocationManager new];
	});
	return instance;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	switch (status) {
		case kCLAuthorizationStatusDenied: {
			// call all callbacks with invalid coordinate
			[self.subscriptionArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				void (^block)(CLLocationCoordinate2D) = obj;
				block(kCLLocationCoordinate2DInvalid);
			}];
			[self.subscriptionArr removeAllObjects];
		}
			break;
		default: {
			// either check whether location is there already, or wait until timeout / error
			if ([IAHLocationManager sharedManager].locManager.location) {
				CLLocationCoordinate2D coord = [IAHLocationManager sharedManager].locManager.location.coordinate;
				[self.subscriptionArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					void (^block)(CLLocationCoordinate2D) = obj;
					block(coord);
				}];
				[self.subscriptionArr removeAllObjects];
			}
		}
			break;
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	// TODO: error handling
	[self.subscriptionArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		void (^block)(CLLocationCoordinate2D) = obj;
		block(kCLLocationCoordinate2DInvalid);
	}];
	[self.subscriptionArr removeAllObjects];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocation *location = [locations lastObject];
	CLLocationCoordinate2D coord = location.coordinate;
	[self.subscriptionArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		void (^block)(CLLocationCoordinate2D) = obj;
		block(coord);
	}];
	[self.locManager stopUpdatingLocation];
}

+ (void)subscribe:(void (^)(CLLocationCoordinate2D))callback {
	[[IAHLocationManager sharedManager].subscriptionArr addObject:callback];
}

+ (CLLocationCoordinate2D)coordinate {
	return [IAHLocationManager sharedManager].locManager.location.coordinate;
}

+ (BOOL)hasLocation {
	return [IAHLocationManager sharedManager].locManager.location != nil ? YES : NO;
}

+ (void)startUpdating {
	[[IAHLocationManager sharedManager].locManager startUpdatingLocation];
}

#pragma mark - public

+ (void)fetchCurrentLocationWithSubscription:(void (^)(CLLocationCoordinate2D))callback {
	NSParameterAssert(callback);
	if ([IAHLocationManager hasLocation]) {
		callback([IAHLocationManager coordinate]);
	} else {
		[IAHLocationManager subscribe:callback];
		[IAHLocationManager startUpdating];
	}
}

@end
