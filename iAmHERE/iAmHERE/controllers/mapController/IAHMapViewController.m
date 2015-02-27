//
//  IAHMapViewController.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHMapViewController.h"
#import "IAHAssetsManager.h"
#import "IAHRouteManager.h"

@interface IAHMapViewController ()

@end

@implementation IAHMapViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"controllers.map.title", @"Title of the map view");
		self.tabBarItem.image = [IAHAssetsManager imageForTabBarMap];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[[IAHRouteManager sharedManager] calculateRoute:
	 ^(IAHItinerary *itinerary, NSError *error) {
		 // TODO:
	 }];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
