//
//  IAHRESTConfigurationTests.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 26/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHRESTConfiguration.h"

@import XCTest;

#define kFieldEndpoint		@"endpoint"
#define kFieldAppID			@"app_id"
#define kFieldAppCode		@"app_code"
#define kFieldVersion		@"version"

@interface IAHRESTConfigurationTests : XCTestCase

@end

@implementation IAHRESTConfigurationTests

- (void)setUp {
	[super setUp];
	// Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}

- (void)testValidTestConfiguration {
	NSDictionary *configDic = @{ kFieldAppCode : @"123",
								 kFieldAppID : @"123",
								 kFieldEndpoint : @"http://example.com",
								 kFieldVersion : @"v1" };
	IAHRESTConfiguration *configuration = [IAHRESTConfiguration configurationWithDic:configDic];
	XCTAssertTrue([configuration isValid], @"configuration is invalid!");
}

- (void)testInvalidTestConfigurationNoEndpoint {
	NSDictionary *configDic = @{ kFieldAppCode : @"123",
								 kFieldAppID : @"123",
								 kFieldVersion : @"v1" };
	IAHRESTConfiguration *configuration = [IAHRESTConfiguration configurationWithDic:configDic];
	XCTAssertFalse([configuration isValid], @"configuration is valid!");
}

- (void)testInvalidTestConfigurationNoVersion {
	NSDictionary *configDic = @{ kFieldAppCode : @"123",
								 kFieldAppID : @"123",
								 kFieldEndpoint : @"http://example.com" };
	IAHRESTConfiguration *configuration = [IAHRESTConfiguration configurationWithDic:configDic];
	XCTAssertFalse([configuration isValid], @"configuration is valid!");
}

- (void)testInvalidTestConfigurationNoAppID {
	NSDictionary *configDic = @{ kFieldAppCode : @"123",
								 kFieldEndpoint : @"http://example.com",
								 kFieldVersion : @"v1" };
	IAHRESTConfiguration *configuration = [IAHRESTConfiguration configurationWithDic:configDic];
	XCTAssertFalse([configuration isValid], @"configuration is valid!");
}

- (void)testInvalidTestConfigurationNoAppCode {
	NSDictionary *configDic = @{ kFieldAppID : @"123",
								 kFieldEndpoint : @"http://example.com",
								 kFieldVersion : @"v1" };
	IAHRESTConfiguration *configuration = [IAHRESTConfiguration configurationWithDic:configDic];
	XCTAssertFalse([configuration isValid], @"configuration is valid!");
}

@end
