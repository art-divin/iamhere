//
//  IAHItinerary.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHMapping.h"

@import CoreData;

@class IAHPlace;
@class IAHRouteSummary;
@class IAHRouteLeg;

@interface IAHItinerary : NSManagedObject <IAHMapping>

@property (nonatomic, strong) NSSet *places;
@property (nonatomic, strong) IAHRouteSummary *summary;
@property (nonatomic, strong) NSSet *legs;

- (NSUInteger)numberOfManeuvers;
- (NSArray *)sortedLegs;
- (NSArray *)sortedPlaces;

@end

@interface IAHItinerary (CoreDataGeneratedAccessors)

- (void)addPlacesObject:(IAHPlace *)value;
- (void)removePlacesObject:(IAHPlace *)value;
- (void)addPlaces:(NSSet *)values;
- (void)removePlaces:(NSSet *)values;

- (void)addLegsObject:(IAHRouteLeg *)value;
- (void)removeLegsObject:(IAHRouteLeg *)value;
- (void)addLegs:(NSSet *)values;
- (void)removeLegs:(NSSet *)values;

@end
