//
//  IAHUIManager.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import UIKit;

@class IAHMapViewController;
@class IAHItineraryViewController;
@class IAHSearchViewController;

@interface IAHUIManager : NSObject

+ (IAHMapViewController *)viewControllerForMap;
+ (IAHItineraryViewController *)viewControllerForItinerary;
+ (IAHSearchViewController *)viewControllerForSearch;

@end
