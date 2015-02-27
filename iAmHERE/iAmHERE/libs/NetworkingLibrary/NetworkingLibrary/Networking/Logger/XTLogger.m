//
//  XTLogger.m
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 18/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "XTLogger.h"

@interface XTLogger ()

@property (nonatomic, assign) XTConfigurationType type;

+ (instancetype)sharedLogger;

@end

@implementation XTLogger

void XTLog(NSString *fmt, ...) {
	if ([XTLogger isLoggingEnabled]) {
		va_list list;
		va_start(list, fmt);
		NSLogv(fmt, list);
		va_end(list);
	}
}

+ (instancetype)sharedLogger {
	static XTLogger *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [XTLogger new];
	});
	return instance;
}

+ (void)setupWithConfiguration:(XTConfigurationType)type {
	[XTLogger sharedLogger].type = type;
}

+ (BOOL)isLoggingEnabled {
	switch ([XTLogger sharedLogger].type) {
		case XTConfigurationTypeDev: return YES; break;
		case XTConfigurationTypeProd: return NO; break;
		default: break;
	}
	return NO;
}

+ (void)log:(dispatch_block_t)block {
	NSParameterAssert(block);
	if ([XTLogger isLoggingEnabled]) {
		block();
	}
}

@end
