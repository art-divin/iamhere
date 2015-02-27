//
//  XTConfiguration.m
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 08/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "XTConfiguration.h"
#import "XTConfigurationInternal.h"

@implementation XTConfigurationPair

- (instancetype)initWithType:(XTConfigurationType)type URL:(NSURL *)url {
    self = [super init];
    if (self) {
        _type = type;
        _url = url;
    }
    return self;
}

+ (instancetype)pairWithType:(XTConfigurationType)type URL:(NSURL *)url {
    NSParameterAssert(url);
    NSAssert(type != XTConfigurationTypeNone, @"invalid type supplied!");
    XTConfigurationPair *retVal = [[XTConfigurationPair alloc] initWithType:type URL:url];
    return retVal;
}

@end

@implementation XTConfiguration

+ (instancetype)configurationWithPairs:(NSArray * (^)())pairBlock type:(XTConfigurationType)type {
	NSParameterAssert(pairBlock);
	NSAssert(type != XTConfigurationTypeNone, @"invalid type supplied!");
	XTConfigurationInternal *retVal = [[XTConfigurationInternal alloc] initWithPairs:pairBlock()];
	retVal.type = type;
	return retVal;
}

@end
