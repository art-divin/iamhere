//
//  IAHMapping.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import Foundation;

@protocol IAHMapping <NSObject>

@required
- (void)deserializeWithDic:(NSDictionary *)dic;

@end
