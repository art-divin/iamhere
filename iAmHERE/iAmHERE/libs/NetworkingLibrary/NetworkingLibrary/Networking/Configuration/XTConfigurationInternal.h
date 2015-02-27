//
//  XTConfigurationInternal.h
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 08/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "XTConfiguration.h"

@interface XTConfigurationInternal : XTConfiguration

- (instancetype)initWithPairs:(NSArray *)pairArr NS_DESIGNATED_INITIALIZER;

/*! This property holds current type of the configuration */
@property (nonatomic, assign) XTConfigurationType type;

/*! This method returns appropriate URL for endpoint according to type of the configuration
 */
- (NSURL *)endpoint;

@end
