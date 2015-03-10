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
// We are abstracting out the PFUser object. What if we want to change it later?
static User *_currentUser;

+(User *)currentUser {
    if (_currentUser == nil) {
        // we may be starting up, grab the PFUser currentUser object and see
        PFUser *pfUser = [PFUser currentUser];
        if (pfUser != nil) {
            _currentUser = [[User alloc] initWithParseObject:pfUser];
        }
    }
    return _currentUser;
}

+(void)loginWithEmail:(NSString *)email andPassword:(NSString *)password andCompletion:(void (^)(User *, NSError *))completion {
    NSError *error = nil;
    // Login
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *pfUser, NSError *error) {
        User *user = nil;
        if (user) {
            user = [[User alloc] initWithParseObject:pfUser];
        }
        _currentUser = user;
        completion(user, error);
        
    }];
    
    // set Current user
    
    if (completion != nil) {
        completion(nil, error);
    }
}

+(void)signUpWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)email andPassword:(NSString *)password andCompletion:(void (^)(User *, NSError *))completion {
    // do some validation
    
    // setup the Parse User object
    PFUser *pfUser = [PFUser user];
    pfUser.username = email;
    pfUser.password = password;
    pfUser.email = email;
    pfUser[@"first_name"] = firstName;
    pfUser[@"last_name"] = lastName;
    
    [pfUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        User *user = nil;
        if (!error) {
            user = [[User alloc] initWithParseObject:pfUser];
        }
        _currentUser = user;
        completion(user, error);
    }];
}

+(void)logout {
    [PFUser logOut];
    _currentUser = nil;
}

+(void)listUsersForCourse:(Course *)course withCompletion:(void (^)(NSArray *, NSError *))completion {
    NSArray *users = nil;
    if (completion) {
        completion(users, nil);
    }
}

+(void)retrieveUserById:(NSInteger)userId withCompletion:(void (^)(User *, NSError *))completion {
    PFUser *pfUser = [[PFUser alloc] initWithClassName:@"User"];
    User *user = [[User alloc] initWithParseObject:pfUser];
    if (completion) {
        completion(user, nil);
    }
}

@end
