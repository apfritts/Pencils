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
#import <UIKit/UIKit.h>
#import "Course.h"
#import "Material.h"

@interface NavigationUtility : NSObject

+(void)registerWindow:(UIWindow *)window;

+(void)navigateToCourseCreate;
+(void)navigateToGlobalCourseListOf:(NSArray *)courses;
+(void)navigateToTeacherCourseListOf:(NSArray *)courses;
+(void)navigateToCourses;
+(void)navigateToEditTeacherCourse:(Course *)course;
+(void)navigateToGlobalCourse:(Course *)course;
+(void)navigateToHome;
+(void)navigateToTeachCourse:(Course *)course;
+(void)navigateToTeacherCourse:(Course *)course;
+(void)navigateToMaterial:(Material *)material;
+(void)navigateToMaterialUpload;

+(void)progressBegin;
+(void)progressBeginInView:(UIView *)view;
+(void)progressStop;

+(void)login;
+(void)logout;

@end
