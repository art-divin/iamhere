//
//  IAHPersistenceManager.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHMapping.h"

@import CoreData;

@interface IAHPersistenceManager : NSObject

+ (id <IAHMapping>)createObjectWithType:(Class)type;
+ (id <IAHMapping>)objectWithType:(Class)type
						predicate:(NSString *)predicateFmt
						arguments:(NSArray *)argsArr;
+ (NSArray *)objectsWithType:(Class)type
				   predicate:(NSString *)predicateFmt
				   arguments:(NSArray *)argsArr
			 sortDescriptors:(NSArray *)sortDescrArr;
+ (void)deleteObject:(id <IAHMapping>)object;
+ (void)saveContext:(void (^)(NSError *))callback;

@end
