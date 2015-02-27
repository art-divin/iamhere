//
//  IAHRouteManeuver.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 27/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHMapping.h"

@import CoreData;
@import MapKit;

@class IAHRouteLeg;

@interface IAHRouteManeuver : NSManagedObject <IAHMapping>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSNumber *idx;
@property (nonatomic, strong) NSString *instruction;
@property (nonatomic, strong) NSNumber *length;
@property (nonatomic, strong) NSNumber *travelTime;
@property (nonatomic, strong) IAHRouteLeg *leg;

- (CLLocation *)location;

@end
