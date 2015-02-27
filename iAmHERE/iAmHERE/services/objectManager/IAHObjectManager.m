//
//  IAHObjectManager.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHObjectManager.h"
#import "IAHRESTManager.h"
#import "IAHPersistenceManager.h"

@implementation IAHObjectManager

+ (void)fetchPlacesForQuery:(NSString *)query
				 coordinate:(CLLocationCoordinate2D)coordinate
				   callback:(void (^)(NSArray *, XTResponseError *))callback
{
	NSParameterAssert(query);
	NSParameterAssert(callback);
	[IAHRESTManager fetchPlacesForQuery:query
							 atLocation:coordinate
						completionBlock:
	 ^(NSArray *result, XTResponseError *error) {
		 if (error) {
			 // TODO: handle errors
		 } else {
			 NSArray *placeIDArr = [result valueForKey:@"id"];
			 NSArray *existingPlaceArr = [IAHPersistenceManager objectsWithType:[IAHPlace class]
																	  predicate:@"self.identifier in %@"
																	  arguments:@[ placeIDArr ]
																sortDescriptors:nil];
			 NSMutableArray *placeArr = [[NSMutableArray alloc] initWithCapacity:result.count];
			 [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				 NSDictionary *placeDic = obj;
				 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.identifier == %@", placeDic[@"id"]];
				 NSArray *filteredArr = [existingPlaceArr filteredArrayUsingPredicate:predicate];
				 IAHPlace *place = [filteredArr firstObject];
				 if (!place) {
					 place = [IAHPersistenceManager createObjectWithType:[IAHPlace class]];
				 }
				 [place deserializeWithDic:placeDic];
				 [placeArr addObject:place];
			 }];
			 [IAHPersistenceManager saveContext:^(NSError *error) {
				 XTResponseError *err = nil;
				 if (error) {
					 err = [XTResponseError errorWithCode:1 message:NSLocalizedString(@"errors.cache.save", @"Unable to save cache error message")];
				 }
				 callback(placeArr, err);
			 }];
		 }
	 }];
}

@end
