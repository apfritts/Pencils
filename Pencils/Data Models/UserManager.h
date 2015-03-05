//
//  UserManager.h
//  Pencils
//
//  Created by AP Fritts on 3/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "User.h"

@interface UserManager : NSObject

+(User *)currentUser;
+(User *)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
+(void)logout;

+(NSArray *)listUsersForCourse:(Course *)course;
+(User *)retrieveUserById:(NSInteger)userId;

@end
