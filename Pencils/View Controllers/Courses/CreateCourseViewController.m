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
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation CreateCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Create Course";
    self.descriptionView.layer.cornerRadius = 8;
    self.descriptionTextView.layer.cornerRadius = 8;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(onCreateTap)];
}

-(void)onCreateTap {
    [NavigationUtility progressBegin];
    NSDictionary *dictionary = @{
                                 @"name": self.nameField.text,
                                 @"description": self.descriptionTextView.text
                                 };
    [CourseManager createCourseWithDictionary:dictionary withCompletion:^(Course *course, NSError *error) {
        [NavigationUtility progressStop];
        if (error) {
            NSString *errorMessage = error.description;
            if (error.userInfo[@"validate"]) {
                errorMessage = error.userInfo[@"validate"][0];
            }
            [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [NavigationUtility navigateToGlobalCourse:course];
        }
    }];
}

@end
