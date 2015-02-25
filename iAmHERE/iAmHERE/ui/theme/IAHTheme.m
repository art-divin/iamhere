//
//  IAHTheme.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHTheme.h"

@interface IAHTheme ()

@property (nonatomic, assign) Class <IAHThemeInterface> themeClass;

+ (instancetype)sharedTheme;

@end

@implementation IAHTheme

+ (instancetype)sharedTheme {
	static IAHTheme *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [IAHTheme new];
	});
	return instance;
}

+ (void)registerThemeClass:(Class <IAHThemeInterface>)aClass {
	NSParameterAssert(aClass);
	if ([(NSObject *)aClass conformsToProtocol:@protocol(IAHThemeInterface)]) {
		[IAHTheme sharedTheme].themeClass = aClass;
	}
}

+ (UIColor *)colorFromHEX:(NSUInteger)hexValue {
	return [IAHTheme colorFromHEX:hexValue alpha:1.0f];
}

+ (UIColor *)colorFromHEX:(NSUInteger)hexValue alpha:(CGFloat)alpha {
	return [UIColor colorWithRed:(CGFloat)((hexValue & 0xFF0000) >> 16) / 255.0f
						   green:(CGFloat)((hexValue & 0xFF00) >> 8) / 255.0f
							blue:(CGFloat)(hexValue & 0xFF) / 255.0f
						   alpha:alpha];
}

#pragma mark - Colours

+ (UIColor *)colorForViewBackground {
	if ([IAHTheme sharedTheme].themeClass) {
		if ([(NSObject *)[IAHTheme sharedTheme].themeClass respondsToSelector:_cmd]) {
			return [[IAHTheme sharedTheme].themeClass colorForViewBackground];
		}
	}
	return nil;
}

@end
