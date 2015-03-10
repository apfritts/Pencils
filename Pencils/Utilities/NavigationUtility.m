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

#import "NavigationUtility.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// Courses
#import "CoursesViewController.h"
#import "CreateCourseViewController.h"
#import "EditCourseViewController.h"
#import "GlobalCourseViewController.h"
#import "TeachACourseViewController.h"
#import "TeacherCourseViewController.h"

// Home
#import "HomeViewController.h"

// Login and Signup
#import "LoginViewController.h"
#import "SignupViewController.h"

// Materials
#import "ViewMaterialViewController.h"

// Upload
#import "UploadViewController.h"

@interface NavigationUtility()

+(void)pushViewController:(UIViewController *)viewController;

@end

@implementation NavigationUtility

# pragma mark - Courses

+(void)navigateToCourseCreate {
    [NavigationUtility pushViewController:[[CreateCourseViewController alloc] init]];
}

+(void)navigateToGlobalCourseListOf:(NSArray *)courses {
    [NavigationUtility pushViewController:[[CoursesViewController alloc] initWithGlobalCourses:courses]];
}

+(void)navigateToTeacherCourseListOf:(NSArray *)courses {
    [NavigationUtility pushViewController:[[CoursesViewController alloc] initWithTeacherCourses:courses]];
}

+(void)navigateToCourses {
    // Sets to Courses tab controller
}

+(void)navigateToEditTeacherCourse:(Course *)course {
    [NavigationUtility pushViewController:[[EditCourseViewController alloc] initWithCourse:course]];
}

+(void)navigateToGlobalCourse:(Course *)course {
    [NavigationUtility pushViewController:[[GlobalCourseViewController alloc] initWithGlobalCourse:course]];
}

+(void)navigateToTeacherCourse:(Course *)course {
    [NavigationUtility pushViewController:[[TeacherCourseViewController alloc] initWithCourse:course]];
}

+(void)navigateToTeachCourse:(Course *)course {
    [NavigationUtility pushViewController:[[TeachACourseViewController alloc] initWithCourse:course]];
}

# pragma mark - Home

+(void)navigateToHome {
    // Replaces root view of Tab Controller
    registeredWindow.rootViewController = [[HomeViewController alloc] init];
}

# pragma mark - Login & Signup

+(void)login {
    // Create the root tab bar and controller
    tabBarController = [[UITabBarController alloc] init];
    UINavigationController *homeNavController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    UINavigationController *coursesNavController = [[UINavigationController alloc] initWithRootViewController:[[CoursesViewController alloc] init]];
    [tabBarController setViewControllers:@[
                                           homeNavController,
                                           coursesNavController
                                           ]];
    registeredWindow.rootViewController = tabBarController;
}

+(void)logout {
    // Replaces root view controller with LoginViewController
    [PFUser logOut];
    registeredWindow.rootViewController = [[LoginViewController alloc] init];
    tabBarController = nil;
}

# pragma mark - Material & Upload

+(void)navigateToMaterial:(Material *)material {
    [NavigationUtility pushViewController:[[ViewMaterialViewController alloc] initWithMaterial:material]];
}

+(void)navigateToMaterialUpload {
    // Presents this view controller over current view controller, unless it is the login screen.
    // A user must login and then present this view controller over the HomeViewController
}

# pragma mark - Utilities

static UIWindow *registeredWindow;
static UITabBarController *tabBarController;

+(void)registerWindow:(UIWindow *)window {
    registeredWindow = window;
}

+(void)pushViewController:(UIViewController *)viewController {
    // Since each tab is a UINavigationController, we type cast so we can push on the new ViewController
    UINavigationController *selectedViewController = (UINavigationController *)[tabBarController selectedViewController];
    [selectedViewController pushViewController:viewController animated:YES];
}

@end
