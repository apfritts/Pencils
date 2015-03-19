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

#import "User.h"
#import <Parse/Parse.h>

@interface User() <NSCopying>

@property (strong, nonatomic) PFUser *_persistance;

@end

@implementation User

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.firstName = dictionary[@"first_name"];
        self.lastName = dictionary[@"last_name"];
        self.email = dictionary[@"email"];
        self.password = dictionary[@"password"];
        
        PFUser *pfUser = [PFUser user];
        pfUser.username = self.email;
        pfUser.password = self.password;
        pfUser.email = self.email;
        pfUser[@"first_name"] = self.firstName;
        pfUser[@"last_name"] = self.lastName;
        self._persistance = pfUser;
    }
    return self;
}

-(instancetype)initWithParseObject:(PFUser *)pfUser {
    self = [super init];
    if (self) {
        self.firstName = [pfUser objectForKey:@"first_name"];
        self.lastName = [pfUser objectForKey:@"last_name"];
        self.email = pfUser.username;
        self._persistance = pfUser;
    }
    return self;
}

-(NSArray *)validate {
    // @TODO: validate the model and return an array of issues if necessary
    return @[];
}

-(void)saveWithCompletion:(void (^)(NSError *error))completion {
    NSArray *validate = [self validate];
    if (validate.count > 0) {
        completion([[NSError alloc] initWithDomain:@"com.box.Pencils" code:1 userInfo:@{@"validate": validate}]);
        return;
    }
    self._persistance[@"first_name"] = self.firstName;
    self._persistance[@"last_name"] = self.lastName;
    if (self.password) {
        self._persistance.password = self.password;
    }
    [self._persistance saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

-(PFUser *)persistance {
    return self._persistance;
}

- (id)copyWithZone:(NSZone *)zone {
    NSDictionary *userDictionary = @{
        @"first_name" : self.firstName,
        @"last_name" : self.lastName,
        @"email" : self.email,
        @"password" : self.password
    };
    return [[self class] initWithDictionary:userDictionary];
}

@end
