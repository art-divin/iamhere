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

@interface IAHItinerary : NSManagedObject <IAHMapping>

@property (nonatomic, strong) NSSet *places;

- (NSArray *)sortedPlaces;

@end

@interface IAHItinerary (CoreDataGeneratedAccessors)

- (void)addPlacesObject:(IAHPlace *)value;
- (void)removePlacesObject:(IAHPlace *)value;
- (void)addPlaces:(NSSet *)values;
- (void)removePlaces:(NSSet *)values;

@end
