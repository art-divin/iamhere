//
//  IAHAssetsManager.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 27/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHAssetsManager.h"

@implementation IAHAssetsManager

+ (UIImage *)imageForTabBarMap {
	return [UIImage imageNamed:@"Map"];
}

+ (UIImage *)imageForTabBarSearch {
	return [UIImage imageNamed:@"Search"];
}

+ (UIImage *)imageForTabBarItinerary {
	return [UIImage imageNamed:@"Route"];
}

@end
