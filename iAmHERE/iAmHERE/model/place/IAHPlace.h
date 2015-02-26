//
//  IAHPlace.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHMapping.h"

@import CoreData;
@import MapKit;

@interface IAHPlace : NSManagedObject <IAHMapping>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *averageRating;
@property (nonatomic, strong) NSString *vicinity;
@property (nonatomic, strong) NSString *type;

- (NSURL *)hrefURL;
- (NSURL *)iconURL;
- (CLLocation *)location;

@end
