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

#import <UIKit/UIKit.h>
#import "NavigationUtility.h"
#import "HomeViewController.h"
#import "GlobalCourseViewController.h"
#import "LoginViewController.h"

@interface NavigationUtility()

+(void)pushViewController:(UIViewController *)viewController;

@end

@implementation NavigationUtility
static UIWindow *registeredWindow;
static UITabBarController *tabBarController;

+(void)registerWindow:(UIWindow *)window {
    registeredWindow = window;
}

+(void)navigateToCourseCreate {
    // pushViewController onto NavigationController
}

+(void)navigateToCourseListOf:(NSArray* (^)())courses {
    // pushViewController onto NavigationController
}

+(void)navigateToCourses {
    // Replaces root view of Tab Controller
}

+(void)navigateToEditTeacherCourse:(Course *)course {
    // pushViewController onto NavigationController
}

+(void)navigateToHome {
    // Replaces root view of Tab Controller
    registeredWindow.rootViewController = [[HomeViewController alloc] init];
}

+(void)navigateToGlobalCourse:(Course *)course {
    // pushViewController onto NavigationController
}

+(void)navigateToLogin {
    registeredWindow.rootViewController = [[LoginViewController alloc] init];
}

+(void)navigateToMaterial:(Material *)material {
    // pushViewController onto NavigationController
}

+(void)navigateToMaterialUpload {
    // Presents this view controller over current view controller, unless it is the login screen.
    // A user must login and then present this view controller over the HomeViewController
}

+(void)navigateToTeacherCourse:(Course *)course {
    // pushViewController onto NavigationController
}

+(void)navigateToTeachCourse:(Course *)course {
    // pushViewController onto NavigationController
}

+(void)login {
    // Create the root tab bar and controller
    tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[
                                           [[HomeViewController alloc] init],
                                           [[GlobalCourseViewController alloc] init]
                                           ]];
    registeredWindow.rootViewController = tabBarController;
}

+(void)logout {
    // Replaces root view controller with LoginViewController
}

+(void)pushViewController:(UIViewController *)viewController {
    [registeredWindow.rootViewController.navigationController pushViewController:viewController animated:YES];
}

@end
