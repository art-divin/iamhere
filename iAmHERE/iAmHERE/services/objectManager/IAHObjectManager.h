//
//  IAHObjectManager.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHPlace.h"

@import MapKit;
@import Foundation;
@import Networking;

@interface IAHObjectManager : NSObject

+ (void)fetchPlacesForQuery:(NSString *)query
				 coordinate:(CLLocationCoordinate2D)coordinate
				   callback:(void (^)(NSArray *, XTResponseError *))callback;

@end
