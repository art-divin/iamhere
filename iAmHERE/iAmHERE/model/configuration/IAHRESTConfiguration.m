//
//  IAHRESTConfiguration.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHRESTConfiguration.h"

#define kFieldEndpoint		@"endpoint"
#define kFieldAppID			@"app_id"
#define kFieldAppCode		@"app_code"
#define kFieldVersion		@"version"

@implementation IAHRESTConfiguration

- (instancetype)initWithDic:(NSDictionary *)dic {
	self = [super init];
	if (self) {
		_endpoint = dic[kFieldEndpoint];
		_appCode = dic[kFieldAppCode];
		_appID = dic[kFieldAppID];
		_version = dic[kFieldVersion];
	}
	return self;
}

+ (instancetype)configurationWithDic:(NSDictionary *)dic {
	NSParameterAssert(dic);
	IAHRESTConfiguration *retVal = [[IAHRESTConfiguration alloc] initWithDic:dic];
	return retVal;
}

- (NSURL *)endpointURL {
	NSString *tempStr = [NSString stringWithFormat:@"%@/%@", self.endpoint, self.version];
	return [NSURL URLWithString:tempStr];
}

- (BOOL)isValid {
	BOOL result = YES;
	result = result && self.endpoint.length > 0;
	result = result && self.appCode.length > 0;
	result = result && self.appID.length > 0;
	result = result && self.version.length > 0;
	return result;
}

@end
