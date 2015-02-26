//
//  IAHRESTManager.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import Networking;

@interface IAHRESTManager : NSObject

+ (void)fetchPlacesForQuery:(NSString *)query completionBlock:(void (^)(NSArray *, XTResponseError *))completionBlock;

@end
