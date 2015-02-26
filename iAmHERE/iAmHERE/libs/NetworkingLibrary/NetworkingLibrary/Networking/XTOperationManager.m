//
//  XTOperationManager.m
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 26/09/14.
//  Copyright (c) 2014 Ruslan Alikhamov. All rights reserved.
//

#import "XTOperationManager.h"
#import "XTConfigurationInternal.h"
#import "XTResponseError.h"

@interface XTOperationManager ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) XTConfigurationInternal *configuration;

/*! This method returns endpoint of the back end
 * \returns \c NSURL instance pointing to back end domain
 */
- (NSURL *)endpointURL;

@end

@implementation XTOperationManager

#pragma mark - init

- (instancetype)init {
	self = [super init];
	if (self) {
		_queue = [NSOperationQueue new];
	}
	return self;
}

- (void)setupWithConfiguration:(XTConfiguration *(^)())configurationBlock {
	NSParameterAssert(configurationBlock);
	XTConfiguration *configuration = configurationBlock();
	NSAssert([configuration isKindOfClass:[XTConfigurationInternal class]], @"invalid configuration instance provided! Please allocate configuration using public interface");
	self.configuration = (XTConfigurationInternal *)configuration;
}

#pragma mark - private

- (NSURLComponents *)URLComponents {
	NSURL *endpointURL = self.endpointURL;
	NSURLComponents *comps = [NSURLComponents componentsWithURL:endpointURL resolvingAgainstBaseURL:NO];
	return comps;
}

- (NSURL *)endpointURL {
	return self.configuration.endpoint;
}

- (void)scheduleOperation:(XTRequestOperation *)operation {
	[self.queue addOperation:operation];
}

+ (id)URLQueryWithParams:(NSDictionary *)paramsDic {
	if ([NSURLQueryItem class]) {
		NSMutableArray *retVal = [NSMutableArray new];
		[paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			if ([obj isKindOfClass:[NSString class]]) {
				if ([key isKindOfClass:[NSString class]]) {
					NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:key value:obj];
					[retVal addObject:item];
				}
			}
		}];
		return retVal;
	} else {
		NSMutableString *retVal = [NSMutableString new];
		[paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			NSString *fmt = @"%@=%@";
			if (retVal.length > 0) {
				fmt = @"&%@=%@";
			}
			if ([obj isKindOfClass:[NSString class]]) {
				if ([key isKindOfClass:[NSString class]]) {
					[retVal appendFormat:fmt, key, obj];
				}
			}
		}];
		return retVal;
	}
	return nil;
}

@end
