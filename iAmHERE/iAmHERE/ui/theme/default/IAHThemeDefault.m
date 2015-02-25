//
//  IAHThemeDefault.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHThemeDefault.h"

@implementation IAHThemeDefault

#pragma mark - Colours

+ (UIColor *)colorForViewBackground {
	return [IAHTheme colorFromHEX:0xFFFFFF];
}

+ (UIColor *)colorForViewTint {
	return [IAHTheme colorFromHEX:0x15428C];
}

@end
