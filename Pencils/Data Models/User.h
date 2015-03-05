//
//  User.h
//  Pencils
//
//  Created by AP Fritts on 3/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

enum UserType {
    UserTypeTeacher = 1,
    UserTypeStaff = 2
};

@interface User : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) enum UserType userType;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
