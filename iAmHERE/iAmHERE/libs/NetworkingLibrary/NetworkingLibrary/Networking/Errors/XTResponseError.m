//
//  XTResponseError.m
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 08/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "XTResponseError.h"

@implementation XTResponseError

+ (NSString *)formatMessageWithCode:(NSString *)origMsg code:(NSInteger)code {
	NSParameterAssert(origMsg);
	NSString *retVal = [[NSString alloc] initWithFormat:@"%@ (%ld)", origMsg, (long)code];
	return retVal;
}

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message {
	NSString *formattedMsg = [XTResponseError formatMessageWithCode:message code:code];
	// generalize domains
	XTResponseError *error = [[XTResponseError alloc] initWithDomain:@"FNTempDomain" code:code userInfo:nil];
	error.message = formattedMsg;
	return error;
}

+ (instancetype)errorWithErrorCode:(XTResponseErrorCode)code message:(NSString *)message {
	return [XTResponseError errorWithCode:code message:message];
}

@end
