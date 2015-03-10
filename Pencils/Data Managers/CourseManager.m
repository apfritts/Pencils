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

#import "CourseManager.h"
#import <Parse/Parse.h>

@implementation CourseManager

+(void)createCourseWithDictionary:(NSDictionary *)dictionary withCompletion:(void (^)(Course *, NSError *))completion {
    Course *course = [[Course alloc] initWithDictionary:dictionary];
    if (completion != nil) {
        completion(course, nil);
    }
}

+(void)listGlobalCoursesWithCompletion:(void (^)(NSArray *, NSError *))completion {
    if (completion != nil) {
        completion(@[], nil);
    }
}

+(void)listCourseForUser:(User *)user withCompletion:(void (^)(NSArray *, NSError *))completion {
    if (completion != nil) {
        completion(@[], nil);
    }
}


+(void)retreiveCourseById:(NSInteger)courseId withCompletion:(void (^)(Course *, NSError *))completion {
    Course *course = nil;
    if (completion != nil) {
        completion(course, nil);
    }
}


+(void)searchForCourseByTitle:(NSString *)title inGlobalCourse:(Course *)globalCourse withCompletion:(void (^)(NSArray *, NSError *))completion {
    if (completion != nil) {
        completion(@[], nil);
    }
}

@end
