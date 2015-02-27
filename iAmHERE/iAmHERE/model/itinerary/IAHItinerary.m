//
//  IAHItinerary.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHItinerary.h"
#import "IAHPersistenceManager.h"
#import "IAHRouteSummary.h"
#import "IAHRouteLeg.h"

#define kFieldLegs		@"leg"
#define kFieldSummary	@"summary"

@implementation IAHItinerary

@dynamic places;
@dynamic summary;
@dynamic legs;

#pragma mark - IAHMapping

- (void)deserializeWithDic:(NSDictionary *)dic {
	NSArray *legArr = dic[kFieldLegs];
	if ([legArr isKindOfClass:[NSArray class]]) {
		__weak typeof(self) weakSelf = self;
		[self.legs enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
			[weakSelf.managedObjectContext deleteObject:obj];
		}];
		NSMutableSet *legSet = [NSMutableSet new];
		[legArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSMutableDictionary *legDic = [obj mutableCopy];
			legDic[@"idx"] = @(idx);
			IAHRouteLeg *leg = [IAHPersistenceManager createObjectWithType:[IAHRouteLeg class]];
			[leg deserializeWithDic:legDic];
			[legSet addObject:leg];
		}];
		self.legs = [legSet copy];
	}
	NSDictionary *summaryDic = dic[kFieldSummary];
	if ([summaryDic isKindOfClass:[NSDictionary class]]) {
		IAHRouteSummary *summary = self.summary;
		if (!summary) {
			summary = [IAHPersistenceManager createObjectWithType:[IAHRouteSummary class]];
		}
		[summary deserializeWithDic:summaryDic];
		self.summary = summary;
	}
}

- (NSUInteger)numberOfManeuvers {
	NSSet *retVal = [self.legs valueForKeyPath:@"@distinctUnionOfSets.maneuvers"];
	return [retVal count];
}

- (NSArray *)sortedLegs {
	NSSortDescriptor *sortDescr = [[NSSortDescriptor alloc] initWithKey:@"idx" ascending:YES];
	return [self.legs sortedArrayUsingDescriptors:@[ sortDescr ]];
}

- (NSArray *)sortedPlaces {
	NSSortDescriptor *sortDescr = [[NSSortDescriptor alloc] initWithKey:@"idx" ascending:YES];
	return [self.places sortedArrayUsingDescriptors:@[ sortDescr ]];
}

@end
