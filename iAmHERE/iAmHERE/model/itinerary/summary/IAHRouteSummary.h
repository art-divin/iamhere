//
//  IAHRouteSummary.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 27/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHMapping.h"

@import CoreData;

@interface IAHRouteSummary : NSManagedObject <IAHMapping>

@property (nonatomic, strong) NSNumber *baseTime;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *trafficTime;
@property (nonatomic, strong) NSNumber *travelTime;

@end
