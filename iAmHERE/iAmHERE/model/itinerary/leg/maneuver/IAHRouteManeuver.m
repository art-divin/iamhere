//
//  IAHRouteManeuver.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 27/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHRouteManeuver.h"

#define kFieldIdentifier		@"id"
#define kFieldInstruction		@"instruction"
#define kFieldLength			@"length"
#define kFieldPosition			@"position"
#define kFieldLatitude			@"latitude"
#define kFieldLongitude			@"longitude"
#define kFieldTravelTime		@"travelTime"
#define kFieldIndex				@"idx"

@interface IAHRouteManeuver ()

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@end

@implementation IAHRouteManeuver

@dynamic identifier;
@dynamic instruction;
@dynamic length;
@dynamic travelTime;
@dynamic latitude;
@dynamic longitude;
@dynamic leg;
@dynamic idx;

#pragma mark - IAHMapping

- (void)deserializeWithDic:(NSDictionary *)dic {
	self.identifier = dic[kFieldIdentifier] ?: self.identifier;
	self.instruction = dic[kFieldInstruction] ?: self.instruction;
	self.length = dic[kFieldLength] ?: self.length;
	self.travelTime = dic[kFieldTravelTime] ?: self.travelTime;
	self.idx = dic[kFieldIndex] ?: self.idx;
	NSDictionary *locationDic = dic[kFieldPosition];
	if ([locationDic isKindOfClass:[NSDictionary class]]) {
		self.latitude = locationDic[kFieldLatitude];
		self.longitude = locationDic[kFieldLongitude];
	}
}

- (CLLocation *)location {
	if (self.latitude && self.longitude) {
		CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
		return location;
	}
	return nil;
}

@end
