//
//  IAHObjectManager.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHObjectManager.h"
#import "IAHRESTManager.h"

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
		 
	 }];
}

@end
