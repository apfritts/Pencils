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
    [course saveWithCompletion:^(NSError *error) {
        if (completion != nil) {
            completion(course, error);
        }
    }];
}

+(void)listGlobalCoursesWithCompletion:(void (^)(NSArray *, NSError *))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Course"];
    [query whereKey:@"parent" equalTo:[NSNull null]];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *courses = [NSMutableArray array];
        if (objects) {
            for (PFObject *object in objects) {
                Course *course = [[Course alloc] initWithParseObject:object];
                [courses addObject:course];
            }
        }
        if (completion != nil) {
            completion(courses, error);
        }
    }];
}

+(void)listCourseForCourse:(Course *)parentCourse withCompletion:(void (^)(NSArray *, NSError *))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Course"];
    [query whereKey:@"parent" equalTo:[parentCourse persistance]];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *courses = [NSMutableArray array];
        if (objects) {
            for (PFObject *object in objects) {
                Course *course = [[Course alloc] initWithParseObject:object];
                course.parent = parentCourse;
                [courses addObject:course];
            }
        }
        if (completion != nil) {
            completion(courses, error);
        }
    }];
}

+(void)listCourseForUser:(User *)user withCompletion:(void (^)(NSArray *, NSError *))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Course"];
    [query whereKey:@"user" equalTo:[user persistance]];
    [query includeKey:@"parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *courses = [NSMutableArray array];
        if (objects) {
            for (PFObject *object in objects) {
                Course *course = [[Course alloc] initWithParseObject:object];
                course.user = user;
                [courses addObject:course];
            }
        }
        if (completion != nil) {
            completion(courses, error);
        }
    }];
}


+(void)retreiveCourseById:(NSString *)courseId withCompletion:(void (^)(Course *, NSError *))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Course"];
    [query getObjectInBackgroundWithId:courseId block:^(PFObject *object, NSError *error) {
        Course *course = nil;
        if (object) {
            course = [[Course alloc] initWithParseObject:object];
        }
        if (completion) {
            completion(course, error);
        }
    }];
}


+(void)searchForCourseByTitle:(NSString *)title inGlobalCourse:(Course *)globalCourse withCompletion:(void (^)(NSArray *, NSError *))completion {
    if (completion != nil) {
        completion(@[], nil);
    }
}

@end
