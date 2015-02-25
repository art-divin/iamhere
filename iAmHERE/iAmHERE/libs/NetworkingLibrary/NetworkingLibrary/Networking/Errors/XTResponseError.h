//
//  XTResponseError.h
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 08/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, XTResponseErrorCode) {
	XTResponseErrorCodeUnknown = 0,
	XTResponseErrorCodeInvalidResponseFormat = 1,
	XTResponseErrorCodeValidationError
};

@interface XTResponseError : NSError

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message;
+ (instancetype)errorWithErrorCode:(XTResponseErrorCode)code message:(NSString *)message;

@property (nonatomic, strong) NSString *message;

@end
