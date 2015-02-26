//
//  IAHObjectManager.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import Foundation;
@import Networking;

@interface IAHObjectManager : NSObject

+ (void)fetchPlacesForQuery:(NSString *)query callback:(void (^)(NSArray *, XTResponseError *))callback;

@end
