//
//  IAHRouteLeg.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 27/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHMapping.h"

@import CoreData;

@class IAHRouteManeuver;

@interface IAHRouteLeg : NSManagedObject <IAHMapping>

@property (nonatomic, strong) NSNumber *travelTime;
@property (nonatomic, strong) NSNumber *idx;
@property (nonatomic, strong) NSSet *maneuvers;
@property (nonatomic, strong) NSNumber *length;

- (NSArray *)sortedManeuvers;

@end

@interface IAHRouteLeg (CoreDataGeneratedAccessors)

- (void)addManeuversObject:(IAHRouteManeuver *)value;
- (void)removeManeuversObject:(IAHRouteManeuver *)value;
- (void)addManeuvers:(NSSet *)values;
- (void)removeManeuvers:(NSSet *)values;

@end
