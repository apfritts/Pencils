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
#import "ColorUtility.h"
#import <FontAwesome+iOS/NSString+FontAwesome.h>
#import <FontAwesome+iOS/UIFont+FontAwesome.h>
#import <FontAwesome+iOS/UIImage+FontAwesome.h>

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
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageWithIcon:@"icon-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[ColorUtility tintColor] iconScale:1.0 andSize:CGSizeMake(15.0, 24.0)] forState:UIControlStateNormal];
    [btnBack setTitleColor:[ColorUtility tintColor] forState:UIControlStateNormal];
    [btnBack setTitle:@" Back" forState:UIControlStateNormal];
    btnBack.imageEdgeInsets = UIEdgeInsetsZero;
    btnBack.titleEdgeInsets = UIEdgeInsetsZero;
    [btnBack sizeToFit];
    //btnBack.frame = (CGRect) {.size.width = 65, .size.height = 30};
    //NSString *faBack = [NSString fontAwesomeIconStringForEnum:FAIconChevronLeft];
    //NSMutableAttributedString *back = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Back", faBack]];
    //[back addAttribute:NSFontAttributeName value:[UIFont fontAwesomeFontOfSize:17.0] range:NSMakeRange(0, 1)];
    //UILabel *backLabel = [[UILabel alloc] init];
    //[backLabel setAttributedText:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    //self.navigationItem.leftBarButtonItem.target = self;
    //self.navigationItem.leftBarButtonItem.action = @selector(onBackTap);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onCreateTap)];
}

-(void)onBackTap {
    [self.navigationController popViewControllerAnimated:YES];
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
