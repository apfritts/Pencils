//
//  UserTest.m
//  Pencils
//
//  Created by AP Fritts on 3/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"

@interface UserTests : XCTestCase

@end

@implementation UserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithDictionary {
    NSDictionary *dictionary = @{
                                 @"first_name": @"First",
                                 @"last_name": @"Last",
                                 @"email": @"E-mail",
                                 @"user_type": @"1",
                                 @"password": @"password"
                                 };
    User *user = [[User alloc] initWithDictionary:dictionary];
    XCTAssertEqual(@"First", user.firstName, @"User's first name should be set");
    XCTAssertEqual(@"Last", user.lastName, @"User's last name should be set");
    XCTAssertEqual(@"E-mail", user.email, @"User's e-mail should be set");
    XCTAssertEqual(UserTypeTeacher, user.userType, @"User's type should be UserTypeTeacher");
    XCTAssertNil(user.password, @"User password should not be set on initWithDictionary");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
