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

#import <Foundation/Foundation.h>
#import "Course.h"
#import "User.h"

@interface CourseManager : NSObject

+(void)createCourseWithDictionary:(NSDictionary *)dictionary withCompletion:(void (^)(Course *course, NSError *error))completion;
+(void)listGlobalCoursesWithCompletion:(void (^)(NSArray *courses, NSError *error))completion;
+(void)listCourseForCourse:(Course *)user withCompletion:(void (^)(NSArray *, NSError *))completion;
+(void)listCourseForUser:(User *)user withCompletion:(void (^)(NSArray *courses, NSError *error))completion;
+(void)retreiveCourseById:(NSString *)courseId withCompletion:(void (^)(Course *course, NSError *error))completion;
+(void)searchForCourseByTitle:(NSString *)title inGlobalCourse:(Course *)globalCourse withCompletion:(void (^)(NSArray *courses, NSError *error))completion;

@end
