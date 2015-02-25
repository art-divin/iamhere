//
//  XTRequestOperation.h
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 18/08/14.
//  Copyright (c) 2014 Ruslan Alikhamov. All rights reserved.
//

@import Foundation;

#import "XTGlobals.h"

typedef void (^XTOperationCompletion)(NSDictionary *, NSError *);

typedef NS_ENUM(NSUInteger, XTOperationType) {
	XTOperationTypeGET = 0,
	XTOperationTypePOST,
	XTOperationTypePUT,
	XTOperationTypeDELETE
};

/*! \header \c XTRequestOperation
 * class provides a way for sending GET requests, incapsulates NSURLConnection for networking
 * \brief Use this class to perform networking operations
 */
@interface XTRequestOperation : NSOperation

/*! This property gets filled while response is being received */
@property (nonatomic, strong, readonly) NSMutableData *responseData;
@property (nonatomic, strong, readonly) XTOperationCompletion finishBlock;
@property (nonatomic, strong, readonly) NSMutableURLRequest *request;

+ (instancetype)operationWithURL:(NSURL *)URL
							type:(XTOperationType)type
						 dataDic:(NSDictionary *)dataDic
					 contentType:(NSString *)contentType
					 finishBlock:(XTOperationCompletion)finishBlock;

@end
