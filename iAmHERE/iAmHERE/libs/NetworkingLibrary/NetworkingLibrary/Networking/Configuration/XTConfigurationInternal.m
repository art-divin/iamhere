//
//  XTConfigurationInternal.m
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 08/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "XTConfigurationInternal.h"

@interface XTConfigurationInternal ()

@property (nonatomic, strong) NSArray *pairArr;

@end

@implementation XTConfigurationInternal

- (instancetype)initWithPairs:(NSArray *)pairArr {
	self = [super init];
	if (self) {
		_pairArr = pairArr;
	}
	return self;
}

- (NSURL *)endpoint {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.type == %@", @(self.type)];
	NSArray *filteredArr = [self.pairArr filteredArrayUsingPredicate:predicate];
	XTConfigurationPair *pair = [filteredArr firstObject];
	return pair.url;
}

@end
