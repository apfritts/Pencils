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

#import "UserManager.h"
#import <Parse/Parse.h>

@implementation UserManager
static User *_currentUser;

+(User *)currentUser {
    return _currentUser;
}

+(void)loginWithEmail:(NSString *)email andPassword:(NSString *)password andCompletion:(void (^)(User *user, NSError *error))completion {
    NSError *error = nil;
    // Login
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *pfUser, NSError *error) {
        User *user = nil;
        if (user) {
            user = [[User alloc] initWithDictionary:@{
                                                     @"first_name": pfUser[@"first_name"],
                                                     @"last_name": pfUser[@"last_name"],
                                                     @"email": pfUser.username
                                                     }];
        }
        _currentUser = user;
        completion(user, error);
        
    }];
    
    // set Current user
    
    if (completion != nil) {
        completion(nil, error);
    }
}

+(void)signUpWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)email andPassword:(NSString *)password andCompletion:(void (^)(User *user, NSError *error))completion {
    // do some validation
    
    // setup the Parse User object
    PFUser *pUser = [PFUser user];
    pUser.username = email;
    pUser.password = password;
    pUser.email = email;
    pUser[@"first_name"] = firstName;
    pUser[@"last_name"] = lastName;
    
    [pUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        User *user = nil;
        if (!error) {
            user = [[User alloc] initWithDictionary:@{
                                                     @"first_name": firstName,
                                                     @"last_name": lastName,
                                                     @"email": email
                                                     }];
        }
        _currentUser = user;
        completion(user, error);
    }];
}

+(void)logout {
    // logout
}

+(NSArray *)listUsersForCourse:(Course *)course {
    return nil;
}

+(User *)retrieveUserById:(NSInteger)userId {
    NSDictionary *fakeUser = @{
                               @"first_name": @"Louise",
                               @"last_name": @"Teacher",
                               @"email": @"louise@awesome.com",
                               @"user_id": @"007"
                               };
    return [[User alloc] initWithDictionary:fakeUser];
}

@end
