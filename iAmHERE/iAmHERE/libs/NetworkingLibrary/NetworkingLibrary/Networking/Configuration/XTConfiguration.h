//
//  XTConfiguration.h
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 08/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, XTConfigurationType) {
    XTConfigurationTypeNone = 0,
	XTConfigurationTypeDev,
	XTConfigurationTypeProd
};

@interface XTConfigurationPair : NSObject

@property (nonatomic, readonly, assign) XTConfigurationType type;
@property (nonatomic, readonly, strong) NSURL *url;

+ (instancetype)pairWithType:(XTConfigurationType)type URL:(NSURL *)url;

@end

@interface XTConfiguration : NSObject

+ (instancetype)configurationWithPairs:(NSArray * (^)())pairBlock type:(XTConfigurationType)type;

@end
