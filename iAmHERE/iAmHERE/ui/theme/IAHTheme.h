//
//  IAHTheme.h
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import UIKit;

@protocol IAHThemeInterface <NSObject>

#pragma mark - Colours

@required
+ (UIColor *)colorForViewBackground;
+ (UIColor *)colorForViewTint;

@end

@interface IAHTheme : NSObject <IAHThemeInterface>

+ (void)registerThemeClass:(Class <IAHThemeInterface>)aClass;

+ (UIColor *)colorFromHEX:(NSUInteger)hexValue;
+ (UIColor *)colorFromHEX:(NSUInteger)hexValue alpha:(CGFloat)alpha;

@end
