//
//  IAHRESTManager.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHRESTManager.h"
#import "IAHRESTConfiguration.h"

#define kFieldConfigPlaces		@"PlacesConfig"
#define kFieldConfigRoute		@"RouteConfig"
#define kFieldConfigType		@"plist"
#define kFieldResults			@"results"
#define kFieldItems				@"items"

@interface IAHRESTManager ()

@property (nonatomic, strong) IAHRESTConfiguration *placesConfiguration;
@property (nonatomic, strong) IAHRESTConfiguration *routeConfiguration;
@property (nonatomic, strong) XTOperationManager *placesOperationManager;
@property (nonatomic, strong) XTOperationManager *routeOperationManager;

+ (instancetype)sharedManager;

@end

@implementation IAHRESTManager

- (instancetype)init {
	self = [super init];
	if (self) {
		NSURL *placesConfURL = [[NSBundle mainBundle] URLForResource:kFieldConfigPlaces withExtension:kFieldConfigType];
		NSURL *routeConfURL = [[NSBundle mainBundle] URLForResource:kFieldConfigRoute withExtension:kFieldConfigType];
		NSDictionary *placesConfDic = [NSDictionary dictionaryWithContentsOfURL:placesConfURL];
		NSDictionary *routeConfDic = [NSDictionary dictionaryWithContentsOfURL:routeConfURL];
		_placesConfiguration = [IAHRESTConfiguration configurationWithDic:placesConfDic];
		_routeConfiguration = [IAHRESTConfiguration configurationWithDic:routeConfDic];
		_placesOperationManager = [XTOperationManager new];
		NSURL *placesEndpoint = [_placesConfiguration endpointURL];
		[_placesOperationManager setupWithConfiguration:
		 ^XTConfiguration *{
			 return [XTConfiguration configurationWithPairs:^NSArray *{
				 return @[ [XTConfigurationPair pairWithType:XTConfigurationTypeDev URL:placesEndpoint] ];
			 } type:XTConfigurationTypeDev];
		 }];
		_routeOperationManager = [XTOperationManager new];
		NSURL *routeEndpoint = [_routeConfiguration endpointURL];
		[_routeOperationManager setupWithConfiguration:^XTConfiguration *{
			return [XTConfiguration configurationWithPairs:^NSArray *{
				return @[ [XTConfigurationPair pairWithType:XTConfigurationTypeDev URL:routeEndpoint] ];
			} type:XTConfigurationTypeDev];
		}];
	}
	return self;
}

+ (instancetype)sharedManager {
	static IAHRESTManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [IAHRESTManager new];
	});
	return instance;
}

+ (NSDictionary *)authHeaderDicForConfiguration:(IAHRESTConfiguration *)configuration {
	NSString *appID = configuration.appID;
	NSString *appCode = configuration.appCode;
	NSString *tempStr = [NSString stringWithFormat:@"%@:%@", appID, appCode];
	NSString *base64Str = [[tempStr dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:kNilOptions];
	NSString *authHeaderStr = [NSString stringWithFormat:@"Basic %@", base64Str];
	return @{ @"Authorization" : authHeaderStr };
}

+ (void)fetchPlacesForQuery:(NSString *)query
				 atLocation:(CLLocationCoordinate2D)coordinate
			completionBlock:(void (^)(NSArray *, XTResponseError *))completionBlock
{
	NSParameterAssert(query);
	NSParameterAssert(completionBlock);
	XTOperationManager *opMan = [IAHRESTManager sharedManager].placesOperationManager;
	NSString *locationStr = [NSString stringWithFormat:@"%f,%f;cgen=gps", coordinate.latitude, coordinate.longitude];
	id urlQuery = [XTOperationManager URLQueryWithParams:@{ @"q" : query, @"at" : locationStr }];
	NSURLComponents *comps = [opMan URLComponents];
	comps.path = [comps.path stringByAppendingString:@"/discover/search"];
	if ([NSURLQueryItem class]) {
		comps.queryItems = urlQuery;
	} else {
		comps.query = urlQuery;
	}
	NSDictionary *authHeaderDic = [IAHRESTManager authHeaderDicForConfiguration:[IAHRESTManager sharedManager].placesConfiguration];
	XTRequestOperation *operation = [XTRequestOperation operationWithURL:[comps URL]
																	type:XTOperationTypeGET
																 dataDic:nil
															   headerDic:authHeaderDic
															 contentType:@"application/json"
															 finishBlock:
									 ^(NSDictionary *resultDic, NSDictionary *headerDic, NSError *error) {
										 if (error) {
											 XTResponseError *error = [XTResponseError errorWithCode:error.code message:error.localizedDescription];
											 completionBlock(nil, error);
											 return;
										 }
										 if (!resultDic) {
											 XTResponseError *error = [XTResponseError errorWithCode:0 message:NSLocalizedString(@"errors.response.empty", @"Empty response error message")];
											 completionBlock(nil, error);
											 return;
										 }
										 if (![resultDic isKindOfClass:[NSDictionary class]]) {
											 XTResponseError *error = [XTResponseError errorWithCode:0 message:NSLocalizedString(@"errors.response.invalid", @"Invalid response error message")];
											 completionBlock(nil, error);
											 return;
										 }
										 NSDictionary *resultsDic = resultDic[kFieldResults];
										 if (![resultDic isKindOfClass:[NSDictionary class]]) {
											 XTResponseError *error = [XTResponseError errorWithCode:0 message:NSLocalizedString(@"errors.response.invalid", @"Invalid response error message")];
											 completionBlock(nil, error);
											 return;
										 }
										 NSArray *itemArr = resultsDic[kFieldItems];
										 completionBlock(itemArr, nil);
									 }];
	[opMan scheduleOperation:operation];
}

@end
