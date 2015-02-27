//
//  IAHRouteSummary.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 27/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHRouteSummary.h"

#define kFieldBaseTime		@"baseTime"
#define kFieldDistance		@"distance"
#define kFieldText			@"text"
#define kFieldTrafficTime	@"trafficTime"
#define kFieldTravelTime	@"travelTime"

@implementation IAHRouteSummary

@dynamic baseTime;
@dynamic distance;
@dynamic text;
@dynamic trafficTime;
@dynamic travelTime;

#pragma mark - IAHMapping

- (void)deserializeWithDic:(NSDictionary *)dic {
	self.baseTime = dic[kFieldBaseTime] ?: self.baseTime;
	self.distance = dic[kFieldDistance] ?: self.distance;
	self.text = dic[kFieldText] ?: self.text;
	self.trafficTime = dic[kFieldTrafficTime] ?: self.trafficTime;
	self.travelTime = dic[kFieldTravelTime] ?: self.travelTime;
}

@end
