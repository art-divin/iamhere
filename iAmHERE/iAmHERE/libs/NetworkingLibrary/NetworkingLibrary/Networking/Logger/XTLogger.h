//
//  XTLogger.h
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 18/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "XTConfiguration.h"

@import Foundation;

OBJC_EXTERN void XTLog(NSString *fmt, ...) NS_FORMAT_FUNCTION(1,0);

@interface XTLogger : NSObject

+ (void)setupWithConfiguration:(XTConfigurationType)type;

+ (void)log:(dispatch_block_t)block;

@end
