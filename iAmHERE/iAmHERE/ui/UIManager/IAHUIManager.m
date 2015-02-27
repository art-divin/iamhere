//
//  IAHUIManager.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHUIManager.h"
#import "IAHMapViewController.h"
#import "IAHItineraryViewController.h"
#import "IAHSearchViewController.h"

@implementation IAHUIManager

+ (UINavigationController *)viewControllerForMap {
	IAHMapViewController *mapVC = [IAHMapViewController new];
	UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:mapVC];
	return navCtrl;
}

+ (UINavigationController *)viewControllerForItinerary {
	IAHItineraryViewController *itineraryVC = [IAHItineraryViewController new];
	UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:itineraryVC];
	return navCtrl;
}

+ (IAHSearchViewController *)viewControllerForSearch {
	IAHSearchViewController *searchVC = [IAHSearchViewController new];
	return searchVC;
}

@end
