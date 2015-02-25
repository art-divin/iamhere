//
//  IAHThemeTests.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHTheme.h"

@import UIKit;
@import XCTest;

@interface IAHThemeTests : XCTestCase

@end

@implementation IAHThemeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testColorHEXConversion {
	UIColor *whiteColor = [UIColor whiteColor];
	UIColor *hexedWhiteColor = [IAHTheme colorFromHEX:0xffffff];
	
	CGFloat origRed = 0.0f;
	CGFloat origBlue = 0.0f;
	CGFloat origGreen = 0.0f;
	CGFloat origAlpha = 0.0f;
	
	CGFloat hexRed = 0.0f;
	CGFloat hexBlue = 0.0f;
	CGFloat hexGreen = 0.0f;
	CGFloat hexAlpha = 0.0f;
	
	[whiteColor getRed:&origRed green:&origGreen blue:&origBlue alpha:&origAlpha];
	[hexedWhiteColor getRed:&hexRed green:&hexGreen blue:&hexBlue alpha:&hexAlpha];
	
	CGFloat diffRed = origRed - hexRed;
	CGFloat diffBlue = origBlue - hexBlue;
	CGFloat diffGreen = origGreen - hexGreen;
	CGFloat diffAlpha = origAlpha - hexAlpha;
	
	diffRed = diffRed >= 0 ? diffRed : -diffRed;
	diffBlue = diffBlue >= 0 ? diffBlue : -diffBlue;
	diffGreen = diffGreen >= 0 ? diffGreen : -diffGreen;
	diffAlpha = diffAlpha >= 0 ? diffAlpha : -diffAlpha;
	
	XCTAssertTrue(diffRed < 0.1, @"red channels dosn't match");
	XCTAssertTrue(diffBlue < 0.1, @"blue channels dosn't match");
	XCTAssertTrue(diffGreen < 0.1, @"green channels dosn't match");
	XCTAssertTrue(diffAlpha < 0.1, @"alpha channels dosn't match");
}

@end
