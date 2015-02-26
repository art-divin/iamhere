//
//  IAHLocationManager.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import MapKit;

@interface IAHLocationManager : NSObject

+ (void)fetchCurrentLocationWithSubscription:(void (^)(CLLocationCoordinate2D coordinate))callback;

@end
