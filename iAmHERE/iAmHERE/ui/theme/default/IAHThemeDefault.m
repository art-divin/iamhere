//
//  IAHThemeDefault.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHThemeDefault.h"

@implementation IAHThemeDefault

#pragma mark - Appearance

+ (void)setupAppearance {
	[[UIWindow appearance] setTintColor:[IAHTheme colorForViewTint]];
	[[UISearchBar appearance] setBarTintColor:[IAHTheme colorForBarTint]];
	[[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[IAHTheme colorForButtonTitle]];
	[[UITabBar appearance] setBarTintColor:[IAHTheme colorForBarTint]];
	[[UINavigationBar appearance] setBarTintColor:[IAHTheme colorForBarTint]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [IAHTheme colorForButtonTitle] }];
	[[UITabBar appearance] setTranslucent:NO];
	[[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [IAHTheme colorForButtonTitle] } forState:UIControlStateSelected];
}

#pragma mark - Colours

+ (UIColor *)colorForViewBackground {
	return [IAHTheme colorFromHEX:0xFFFFFF];
}

+ (UIColor *)colorForViewTint {
	return [IAHTheme colorFromHEX:0x15428C];
}

+ (UIColor *)colorForButtonTitle {
	return [IAHTheme colorFromHEX:0xFFFFFF];
}

+ (UIColor *)colorForBarTint {
	return [IAHTheme colorFromHEX:0X15428C];
}

+ (UIColor *)colorForCellTitle {
	return [IAHTheme colorFromHEX:0X15428C];
}

+ (UIColor *)colorForPolyline {
	return [IAHTheme colorFromHEX:0X15428C];
}

#pragma mark - Dimensions

+ (CGFloat)heightForTableViewCell {
	return 44.0f;
}

+ (CGFloat)widthForPolyline {
	return 10.0f;
}

+ (CGFloat)animationDuration {
	return 0.3f;
}

@end
