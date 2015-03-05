//
//  CourseManager.h
//  Pencils
//
//  Created by AP Fritts on 3/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "User.h"

@interface CourseManager : NSObject

+(Course *)createCourseWithDictionary:(NSDictionary *)dictionary;
+(NSArray *)listGlobalCourses;
+(NSArray *)listCourseForUser:(User *)user;
+(Course *)retreiveCourseById:(NSInteger)courseId;
+(NSArray *)searchForCourseByTitle:(NSString *)title inGlobalCourse:(Course *)globalCourse;

@end
