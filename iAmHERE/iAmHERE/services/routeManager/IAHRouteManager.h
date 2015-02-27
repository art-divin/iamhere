//
//  IAHRouteManager.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHItinerary.h"
#import "IAHRouteLeg.h"
#import "IAHRouteManeuver.h"
#import "IAHRouteSummary.h"

@import Foundation;

@interface IAHRouteManager : NSObject

@property (nonatomic, strong, readonly) IAHItinerary *itinerary;

+ (instancetype)sharedManager;

- (void)addPlace:(IAHPlace *)place;
- (void)removePlace:(IAHPlace *)place;
- (void)exchangePlace:(IAHPlace *)place withPlace:(IAHPlace *)withPlace;
- (void)calculateRoute:(void (^)(IAHItinerary *, NSError *))callback;

- (void)saveWithCallback:(void (^)(NSError *))callback;

@end
