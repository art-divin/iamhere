//
//  IAHItinerary.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHItinerary.h"

@implementation IAHItinerary

@dynamic places;

#pragma mark - IAHMapping

- (void)deserializeWithDic:(NSDictionary *)dic {
	// TODO:
}

- (NSArray *)sortedPlaces {
	NSSortDescriptor *sortDescr = [[NSSortDescriptor alloc] initWithKey:@"idx" ascending:YES];
	return [self.places sortedArrayUsingDescriptors:@[ sortDescr ]];
}

@end
