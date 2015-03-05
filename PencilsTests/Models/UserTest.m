/**
 * Purpose:
 *
 * Copyright 2015 Pencils Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
                                 @"email": @"E-mail",
                                 @"first_name": @"First",
                                 @"last_name": @"Last",
                                 @"password": @"password",
                                 @"user_id": @"1",
                                 @"user_type": @"1"
                                 };
    User *user = [[User alloc] initWithDictionary:dictionary];
    XCTAssertEqual(@"E-mail", user.email, @"User's e-mail should be set");
    XCTAssertEqual(@"First", user.firstName, @"User's first name should be set");
    XCTAssertEqual(@"Last", user.lastName, @"User's last name should be set");
    XCTAssertEqual(1, user.userId, @"User's ID should be 1");
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
