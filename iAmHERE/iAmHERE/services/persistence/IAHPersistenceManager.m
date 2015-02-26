//
//  IAHPersistenceManager.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHPersistenceManager.h"

@import Networking;

@interface IAHPersistenceManager ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedManager;

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation IAHPersistenceManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedManager {
	static IAHPersistenceManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [IAHPersistenceManager new];
	});
	return instance;
}

- (NSURL *)applicationDocumentsDirectory {
	// The directory the application uses to store the Core Data store file. This code uses a directory named "com.i.am.here.test.iAmHERE" in the application's documents directory.
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
	// The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iAmHERE" withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
	// Create the coordinator and store
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iAmHERE.sqlite"];
	NSError *error = nil;
	NSString *failureReason = @"There was an error creating or loading the application's saved data.";
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		// Report any error we got.
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
		dict[NSLocalizedFailureReasonErrorKey] = failureReason;
		dict[NSUnderlyingErrorKey] = error;
		error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
		// Replace this with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
	// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (!coordinator) {
		return nil;
	}
	_managedObjectContext = [[NSManagedObjectContext alloc] init];
	[_managedObjectContext setPersistentStoreCoordinator:coordinator];
	return _managedObjectContext;
}

#pragma mark - public API

+ (id <IAHMapping>)createObjectWithType:(Class)type {
	NSParameterAssert(type);
	NSManagedObjectContext *managedObjectContext = [IAHPersistenceManager sharedManager].managedObjectContext;
	NSString *entityName = NSStringFromClass(type);
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	NSManagedObject *retVal = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
	return (id <IAHMapping>)retVal;
}

+ (id <IAHMapping>)objectWithType:(Class)type
						predicate:(NSString *)predicateFmt
						arguments:(NSArray *)argsArr
{
	NSParameterAssert(type);
	NSManagedObjectContext *managedObjectContext = [IAHPersistenceManager sharedManager].managedObjectContext;
	NSString *entityName = NSStringFromClass(type);
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
	if (predicateFmt.length > 0 && argsArr) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFmt argumentArray:argsArr];
		request.predicate = predicate;
	}
	[request setFetchLimit:1];
	NSError *error = nil;
	NSArray *retVal = [managedObjectContext executeFetchRequest:request error:&error];
	if (error) {
		[XTLogger log:^{
			XTLog(@"%@\n%@", [error localizedDescription], [error userInfo]);
		}];
	}
	return [retVal firstObject];
}

+ (NSArray *)objectsWithType:(Class)type
				   predicate:(NSString *)predicateFmt
				   arguments:(NSArray *)argsArr
			 sortDescriptors:(NSArray *)sortDescrArr
{
	NSParameterAssert(type);
	NSManagedObjectContext *managedObjectContext = [IAHPersistenceManager sharedManager].managedObjectContext;
	NSString *entityName = NSStringFromClass(type);
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
	if (predicateFmt.length > 0 && argsArr) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFmt argumentArray:argsArr];
		request.predicate = predicate;
	}
	request.sortDescriptors = sortDescrArr;
	NSError *error = nil;
	NSArray *retVal = [managedObjectContext executeFetchRequest:request error:&error];
	if (error) {
		[XTLogger log:^{
			XTLog(@"%@\n%@", [error localizedDescription], [error userInfo]);
		}];
	}
	return retVal;
}

+ (void)deleteObject:(id <IAHMapping>)object {
	NSParameterAssert(object);
	NSManagedObjectContext *managedObjectContext = [IAHPersistenceManager sharedManager].managedObjectContext;
	[managedObjectContext deleteObject:object];
}

+ (void)saveContext:(void (^)(NSError *))callback {
	NSManagedObjectContext *managedObjectContext = [IAHPersistenceManager sharedManager].managedObjectContext;
	if (managedObjectContext != nil) {
		NSError *error = nil;
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			[XTLogger log:^{
				XTLog(@"%@\n%@", [error localizedDescription], [error userInfo]);
			}];
		}
		callback(error);
	}
}

@end
