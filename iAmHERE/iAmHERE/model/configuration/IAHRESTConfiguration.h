//
//  IAHRESTConfiguration.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import Foundation;

@interface IAHRESTConfiguration : NSObject

@property (nonatomic, strong, readonly) NSString *endpoint;
@property (nonatomic, strong, readonly) NSString *appID;
@property (nonatomic, strong, readonly) NSString *appCode;
@property (nonatomic, strong, readonly) NSString *version;

+ (instancetype)configurationWithDic:(NSDictionary *)dic;

- (NSURL *)endpointURL;
- (BOOL)isValid;

@end
