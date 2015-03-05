//
//  Navigation.h
//  Pencils
//
//  Created by AP Fritts on 3/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "Material.h"

@interface NavigationUtility : NSObject

+(void)navigateToHome;
+(void)navigateToCourses;
+(void)navigateToCourseListOf:(NSArray* (^)())courses;
+(void)navigateToGlobalCourse:(Course *)course;
+(void)navigateToCourseCreate;
+(void)navigateToTeacherCourse:(Course *)course;
+(void)navigateToEditTeacherCourse:(Course *)course;
+(void)navigateToTeachCourse:(Course *)course;
+(void)navigateToMaterial:(Material *)material;
+(void)navigateToMaterialUpload;
+(void)logout;

@end
