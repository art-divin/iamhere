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

+ (void)fetchPlacesForQuery:(NSString *)query callback:(void (^)(NSArray *, XTResponseError *))callback {
	NSParameterAssert(query);
	NSParameterAssert(callback);
	[IAHRESTManager fetchPlacesForQuery:query
						completionBlock:
	 ^(NSArray *result, XTResponseError *error) {
		 
	 }];
}

@end
