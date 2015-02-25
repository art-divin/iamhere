//
//  XTRequestOperation.m
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 18/08/14.
//  Copyright (c) 2014 Ruslan Alikhamov. All rights reserved.
//

#import "XTRequestOperation.h"
#import "XTGlobals.h"
#import "XTConfigurationInternal.h"
#import "XTLogger.h"

@interface XTRequestOperation () <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

- (instancetype)initWithURL:(NSURL *)URL
					   type:(XTOperationType)type
					dataDic:(NSDictionary *)dataDic
				contentType:(NSString *)contentType
				finishBlock:(XTOperationCompletion)finishBlock;

/*! Helper method for converting operation type to strings */
+ (NSString *)HTTPMethodFromType:(XTOperationType)type;

@end

@implementation XTRequestOperation

NSUInteger const XTOperationTimeout = 30;

+ (NSString *)HTTPMethodFromType:(XTOperationType)type {
	switch (type) {
		case XTOperationTypeGET: return @"GET"; break;
		case XTOperationTypeDELETE: return @"DELETE"; break;
		case XTOperationTypePOST: return @"POST"; break;
		case XTOperationTypePUT: return @"PUT"; break;
		default: break;
	}
}

- (instancetype)initWithURL:(NSURL *)URL
					   type:(XTOperationType)type
					dataDic:(NSDictionary *)dataDic
				contentType:(NSString *)contentType
				finishBlock:(XTOperationCompletion)finishBlock
{
	self = [super init];
	if (self) {
		NSAssert(finishBlock, @"nil finishBlock provided!");
		_responseData = [[NSMutableData alloc] init];
		_finishBlock = finishBlock;
		NSAssert(URL, @"invalid url string: %@", URL);
		_request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:XTOperationTimeout];
		[_request addValue:contentType ?: @"application/json" forHTTPHeaderField:type == XTOperationTypeGET ? @"Accept" : @"Content-Type"];
		[_request setHTTPMethod:[XTRequestOperation HTTPMethodFromType:type]];
		if (dataDic) {
			NSError *error = nil;
			NSData *postData = [NSJSONSerialization dataWithJSONObject:dataDic options:kNilOptions error:&error];
			if (error) {
				XTLog(@"%@", [error localizedDescription]);
			}
			[_request setHTTPBody:postData];
		}
	}
	return self;
}

+ (instancetype)operationWithURL:(NSURL *)URL
							type:(XTOperationType)type
						 dataDic:(NSDictionary *)dataDic
					 contentType:(NSString *)contentType
					 finishBlock:(XTOperationCompletion)finishBlock
{
	XTRequestOperation *retVal = [[XTRequestOperation alloc] initWithURL:URL type:type dataDic:dataDic contentType:contentType finishBlock:finishBlock];
	[XTLogger log:^{
		XTLog(@"URL: %@", [URL absoluteString]);
		if (dataDic) {
			XTLog(@"POST BODY: %@", dataDic);
		}
	}];
	return retVal;
}

- (void)start {
	self.connection = [[NSURLConnection alloc] initWithRequest:self.request
													  delegate:self
											  startImmediately:NO];
	// scheduling on the main runloop, however, all networking is done on the background thread because
	// implementation of NSURLConnection is based on sockets, which by themselves are fully asynchronous
	// (c) https://devforums.apple.com/thread/9606
	[self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
							   forMode:NSDefaultRunLoopMode];
	[self.connection start];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (!self.isCancelled) {
		[self.responseData appendData:data];
		return;
	}
	[connection cancel];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if (self.finishBlock) {
		self.finishBlock(nil, error);
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSError *error = nil;
	NSData *responseData = self.responseData;
	[XTLogger log:^{
		NSString *dataStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		XTLog(@"Response Data: %@", dataStr);
	}];
	NSDictionary *parsedJSONDic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
	if (error != nil) {
		XTLog(@"error while parsing response: %@", [error localizedDescription]);
	}
	if (self.finishBlock) {
		self.finishBlock(parsedJSONDic, error);
	}
}

@end
