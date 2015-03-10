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

#import "CreateCourseViewController.h"
#import "NavigationUtility.h"
#import "CourseManager.h"

@interface CreateCourseViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;

@end

@implementation CreateCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Create Course";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(onCreateTap)];
}

-(void)onCreateTap {
    [NavigationUtility progressBegin];
    NSDictionary *dictionary = @{
                                 @"name": self.nameField.text,
                                 @"description": self.descriptionField.text
                                 };
    [CourseManager createCourseWithDictionary:dictionary withCompletion:^(Course *course, NSError *error) {
        [NavigationUtility progressStop];
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
        } else {
            [NavigationUtility navigateToGlobalCourse:course];
        }
    }];
}

@end
