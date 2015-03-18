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
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *pfUser, NSError *error) {
        User *user = nil;
        if (user) {
            user = [[User alloc] initWithParseObject:pfUser];
        }
        _currentUser = user;
        if (completion != nil) {
            completion(user, error);
        }
        
    }];
}

+(void)signUpWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)email andPassword:(NSString *)password andCompletion:(void (^)(User *, NSError *))completion {
    NSDictionary *dictionary = @{
                                 @"first_name": firstName,
                                 @"last_name": lastName,
                                 @"email": email,
                                 @"password": password
                                 };
    User *user = [[User alloc] initWithDictionary:dictionary];
    [[user persistance] signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completion) {
            if (error) {
                _currentUser = nil;
                completion(nil, error);
            } else {
                _currentUser = user;
                completion(user, error);
            }
        }
    }];
}

+(void)logout {
    [PFUser logOut];
    _currentUser = nil;
}

+(void)listUsersForGlobalCourse:(Course *)globalCourse withCompletion:(void (^)(NSArray *, NSError *))completion {
    // Course -> parent Course -> courses -> each user
    PFQuery *query = [PFQuery queryWithClassName:@"Course"];
    [query whereKey:@"parent" equalTo:[globalCourse persistance]];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *users = nil;
        if (objects) {
            users = [NSMutableArray array];
            for (PFObject *course in objects) {
                PFUser *pfUser = (PFUser *)course[@"user"];
                if (pfUser) {
                    [users addObject:[[User alloc] initWithParseObject:pfUser]];
                }
            }
        }
        if (completion) {
            completion(users, error);
        }
    }];
}

+(void)retrieveUserById:(NSString *)userId withCompletion:(void (^)(User *, NSError *))completion {
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:userId block:^(PFObject *object, NSError *error) {
        User *user = nil;
        if (object) {
            user = [[User alloc] initWithParseObject:(PFUser *)object];
        }
        if (completion) {
            completion(user, error);
        }
    }];
}

@end
