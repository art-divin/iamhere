//
//  IAHRESTManager.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import MapKit;
@import Networking;

@interface IAHRESTManager : NSObject

+ (void)fetchPlacesForQuery:(NSString *)query
				 atLocation:(CLLocationCoordinate2D)coordinate
			completionBlock:(void (^)(NSArray *, XTResponseError *))completionBlock;

+ (void)fetchRouteForLocations:(NSArray *)locArr
				 transportType:(NSString *)transportType
			   completionBlock:(void (^)(NSArray *, XTResponseError *))completionBlock;

@end
