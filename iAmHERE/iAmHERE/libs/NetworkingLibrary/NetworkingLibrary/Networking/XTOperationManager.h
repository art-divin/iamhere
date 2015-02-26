//
//  XTOperationManager.h
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 26/09/14.
//  Copyright (c) 2014 Ruslan Alikhamov. All rights reserved.
//

#import "XTGlobals.h"
#import "XTConfiguration.h"
#import "XTRequestOperation.h"

@import Foundation;

/*! \header \c XTOperationManager
 * class provides methods for fetching data from back end and encapsulates
 * networking code
 * \brief Use this class to perform networking tasks
 */
@interface XTOperationManager : NSObject

- (NSURLComponents *)URLComponents;
- (void)scheduleOperation:(XTRequestOperation *)operation;
- (void)setupWithConfiguration:(XTConfiguration *(^)())configurationBlock;

/*! This method returns either NSString configured from specified
 * dictionary (iOS 7.x), or \c NSArray of \c NSURLQueryItem instances (iOS 8.x)
 */
+ (id)URLQueryWithParams:(NSDictionary *)paramsDic;

@end
