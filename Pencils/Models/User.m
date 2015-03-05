//
//  User.m
//  Pencils
//
//  Created by AP Fritts on 3/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.firstName = dictionary[@"first_name"];
        self.lastName = dictionary[@"last_name"];
        self.email = dictionary[@"email"];
        self.userType = (int)[dictionary[@"user_type"] integerValue];
    }
    return self;
}

@end
