//
//  IAHRouteLeg.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 27/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHRouteLeg.h"
#import "IAHRouteManeuver.h"
#import "IAHPersistenceManager.h"

#define kFieldTravelTime		@"travelTime"
#define kFieldManeuvers			@"maneuver"
#define kFieldLength			@"length"
#define kFieldIndex				@"idx"

@implementation IAHRouteLeg

@dynamic travelTime;
@dynamic maneuvers;
@dynamic length;
@dynamic idx;

#pragma mark - IAHMapping

- (void)deserializeWithDic:(NSDictionary *)dic {
	self.travelTime = dic[kFieldTravelTime] ?: self.travelTime;
	self.length = dic[kFieldLength] ?: self.length;
	self.idx = dic[kFieldIndex] ?: self.idx;
	NSArray *maneuverArr = dic[kFieldManeuvers];
	if ([maneuverArr isKindOfClass:[NSArray class]]) {
		__weak typeof(self) weakSelf = self;
		[self.maneuvers enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
			[weakSelf.managedObjectContext deleteObject:obj];
		}];
		NSMutableSet *maneuverSet = [NSMutableSet new];
		[maneuverArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSMutableDictionary *maneuverDic = [obj mutableCopy];
			maneuverDic[@"idx"] = @(idx);
			IAHRouteManeuver *maneuver = [IAHPersistenceManager createObjectWithType:[IAHRouteManeuver class]];
			[maneuver deserializeWithDic:maneuverDic];
			[maneuverSet addObject:maneuver];
		}];
		self.maneuvers = [maneuverSet copy];
	}
}

- (NSArray *)sortedManeuvers {
	NSSortDescriptor *sortDescr = [[NSSortDescriptor alloc] initWithKey:@"idx" ascending:YES];
	return [self.maneuvers sortedArrayUsingDescriptors:@[ sortDescr ]];
}

@end
