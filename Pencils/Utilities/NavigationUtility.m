//
//  Navigation.m
//  Pencils
//
//  Created by AP Fritts on 3/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationUtility.h"

@implementation NavigationUtility

+(void)navigateToHome {
    // Replaces root view of Tab Controller
}

+(void)navigateToCourses {
    // Replaces root view of Tab Controller
}

+(void)navigateToCourseListOf:(NSArray* (^)())courses {
    // pushViewController onto NavigationController
}

+(void)navigateToGlobalCourse:(Course *)course {
    // pushViewController onto NavigationController
}

+(void)navigateToCourseCreate {
    // pushViewController onto NavigationController
}

+(void)navigateToTeacherCourse:(Course *)course {
    // pushViewController onto NavigationController
}

+(void)navigateToEditTeacherCourse:(Course *)course {
    // pushViewController onto NavigationController
}

+(void)navigateToTeachCourse:(Course *)course {
    // pushViewController onto NavigationController
}

+(void)navigateToMaterial:(Material *)material {
    // pushViewController onto NavigationController
}

+(void)navigateToMaterialUpload {
    // Presents this view controller over current view controller, unless it is the login screen.
    // A user must login and then present this view controller over the HomeViewController
}

+(void)logout {
    // Replaces root view controller with LoginViewController
}

@end
