//
//  IAHPlace.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHPlace.h"

#define kFieldPosition		@"position"
#define kFieldDistance		@"distance"
#define kFieldTitle			@"title"
#define kFieldAverageRating	@"averageRating"
#define kFieldIcon			@"icon"
#define kFieldVicinity		@"vicinity"
#define kFieldType			@"type"
#define kFieldHref			@"href"
#define kFieldIdentifier	@"id"

@interface IAHPlace ()

@property (nonatomic, strong) NSString *iconURLStr;
@property (nonatomic, strong) NSString *href;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@end

@implementation IAHPlace

@dynamic identifier;
@dynamic latitude;
@dynamic longitude;
@dynamic distance;
@dynamic title;
@dynamic averageRating;
@dynamic vicinity;
@dynamic type;
@dynamic iconURLStr;
@dynamic href;
@dynamic idx;
@dynamic itinerary;

#pragma mark - IAHMapping

- (void)deserializeWithDic:(NSDictionary *)dic {
	self.identifier = dic[kFieldIdentifier] ?: self.identifier;
	NSArray *locationArr = dic[kFieldPosition];
	if ([locationArr isKindOfClass:[NSArray class]]) {
		if (locationArr.count == 2) {
			self.latitude = [locationArr firstObject];
			self.longitude = [locationArr lastObject];
		}
	}
	self.distance = dic[kFieldDistance] ?: self.distance;
	self.title = dic[kFieldTitle] ?: self.title;
	self.averageRating = dic[kFieldAverageRating] ?: self.averageRating;
	self.vicinity = dic[kFieldVicinity] ?: self.vicinity;
	self.type = dic[kFieldType] ?: self.type;
	self.iconURLStr = dic[kFieldIcon] ?: self.iconURLStr;
	self.href = dic[kFieldHref] ?: self.href;
}

#pragma mark - accessors

- (NSURL *)iconURL {
	return [NSURL URLWithString:self.iconURLStr];
}

- (NSURL *)hrefURL {
	return [NSURL URLWithString:self.href];
}

- (CLLocation *)location {
	if (self.latitude && self.longitude) {
		CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
		return location;
	}
	return nil;
}

@end
