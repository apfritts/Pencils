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

#import "ColorUtility.h"
#import <MRProgress/MRProgress.h>
#import "NavigationUtility.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

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

// Materials
#import "MaterialImporter.h"
#import "ViewMaterialViewController.h"

@interface NavigationUtility()

+(void)pushViewController:(UIViewController *)viewController;

@end

@implementation NavigationUtility

# pragma mark - Courses

+(void)navigateToCourseCreate {
    [NavigationUtility pushViewController:[[CreateCourseViewController alloc] init]];
}

+(void)navigateToCourseListOf:(NSArray *)courses {
    [NavigationUtility pushViewController:[[CoursesViewController alloc] initWithCourses:courses]];
}

+(void)navigateToCourses {
    [tabBarController setSelectedIndex:1];
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
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObject:[ColorUtility tintColor] forKey:NSForegroundColorAttributeName];
    homeNavController.navigationBar.barTintColor = [ColorUtility backgroundColor];
    homeNavController.navigationBar.titleTextAttributes = titleTextAttributes;
    homeNavController.navigationBar.tintColor = [ColorUtility tintColor];
    UINavigationController *coursesNavController = [[UINavigationController alloc] initWithRootViewController:[[CoursesViewController alloc] init]];
    coursesNavController.navigationBar.barTintColor = [ColorUtility backgroundColor];
    coursesNavController.navigationBar.titleTextAttributes = titleTextAttributes;
    coursesNavController.navigationBar.tintColor = [ColorUtility tintColor];
    [tabBarController setViewControllers:@[
                                           homeNavController,
                                           coursesNavController
                                           ]];
    tabBarController.tabBar. barTintColor = [ColorUtility backgroundColor];
    tabBarController.tabBar.tintColor = [ColorUtility tintColor];
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

+(void)navigateToMaterialImport:(Course *)course {
    //
}

+(void)navigateToMaterialUpload {
    // Presents this view controller over current view controller, unless it is the login screen.
    // A user must login and then present this view controller over the HomeViewController
}

# pragma mark - Progress
static UIView *currentProgressBackground;
static MRActivityIndicatorView *currentProgress;

+(void)progressBegin {
    [NavigationUtility progressBeginInView:registeredWindow.rootViewController.view];
}

+(void)progressBeginInView:(UIView *)view {
    if (currentProgress != nil) {
        [NavigationUtility progressStop];
    }
    CGFloat width = 160.0;
    CGFloat height = 160.0;
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    CGRect popupViewRect = CGRectMake((windowSize.width / 2) - (width / 2), (windowSize.height / 2) - (height / 2), width, height);
    currentProgressBackground = [[UIView alloc] initWithFrame:popupViewRect];
    currentProgressBackground.backgroundColor = [ColorUtility shadedBackground];
    currentProgressBackground.layer.cornerRadius = width / 2;
    [view addSubview:currentProgressBackground];
    
    currentProgress = [[MRActivityIndicatorView alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
    currentProgress.tintColor = [ColorUtility primaryColor];
    currentProgress.backgroundColor = [UIColor clearColor];
    [currentProgressBackground addSubview:currentProgress];
    [currentProgress startAnimating];
}

+(void)progressStop {
    [currentProgressBackground removeFromSuperview];
    [currentProgress removeFromSuperview];
    [currentProgress stopAnimating];
    currentProgress = nil;
    currentProgressBackground = nil;
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
