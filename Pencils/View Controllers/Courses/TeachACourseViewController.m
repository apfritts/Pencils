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

#import "TeachACourseViewController.h"
#import "ColorUtility.h"
#import "CourseManager.h"
#import "NavigationUtility.h"
#import "UserManager.h"
#import <THCalendarDatePicker/THDatePickerViewController.h>

@interface TeachACourseViewController () <THDatePickerDelegate>

@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) THDatePickerViewController *datePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) UIButton *selectedDateButton;
@property (assign, nonatomic) enum {START_DATE = 0, END_DATE = 1} selectedDate;

@end

@implementation TeachACourseViewController

-(instancetype)initWithCourse:(Course *)course {
    self = [super init];
    if (self) {
        self.course = course;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup the nav bar
    self.title = @"Teach Course";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Teach!" style:UIBarButtonItemStylePlain target:self action:@selector(onTeachTap)];
    
    // Define the date formatter
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    // Setup the date picker
    self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setAutoCloseOnSelectDate:YES];
    [self.datePicker setAllowSelectionOfSelectedDate:YES];
    [self.datePicker setSelectedBackgroundColor:[ColorUtility primaryColor]];
    [self.datePicker setDisableFutureSelection:NO];
    [self.datePicker setDisableHistorySelection:NO];
}

-(void)onTeachTap {
    // @TODO: Move to data model
    if (!self.startDate) {
        [[[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"You have to select a start date!" delegate:nil cancelButtonTitle:@"Fix it" otherButtonTitles:nil] show];
        return;
    }
    if (!self.endDate) {
        [[[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"You have to select an end date!" delegate:nil cancelButtonTitle:@"Fix it" otherButtonTitles:nil] show];
        return;
    }
    if (self.startDate > self.endDate) {
        [[[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"The start date is after the end date.\n\nYou cannot start the class after it ended!" delegate:nil cancelButtonTitle:@"Whoops!" otherButtonTitles:nil] show];
        return;
    }
    
    // Create the course
    [NavigationUtility progressBegin];
    NSDictionary *dictionary = @{
                                 @"name": self.course.name,
                                 @"start": self.startDate,
                                 @"end": self.endDate,
                                 @"parent": self.course,
                                 @"user": [UserManager currentUser]
                                 };
    [CourseManager createCourseWithDictionary:dictionary withCompletion:^(Course *course, NSError *error) {
        [NavigationUtility progressStop];
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.debugDescription delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [NavigationUtility navigateToTeacherCourse:course];
        }
    }];
}

- (IBAction)courseStartsTap:(id)sender {
    [self showDatePickerForField:START_DATE withButton:(UIButton *)sender];
}

- (IBAction)courseEndsTap:(id)sender {
    [self showDatePickerForField:END_DATE withButton:(UIButton *)sender];
}

-(void)showDatePickerForField:(int)field withButton:(UIButton *)button {
    self.selectedDate = field;
    self.selectedDateButton = button;
    if (field == START_DATE) {
        self.datePicker.date = self.startDate;
    } else {
        self.datePicker.date = self.endDate;
    }
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(0.3),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3)
                                                                  }];
}

-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalViewWithCompletion:nil];
}

-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    if (datePicker.date != nil) {
        if (self.selectedDate == START_DATE) {
            self.startDate = datePicker.date;
        } else {
            self.endDate = datePicker.date;
        }
        [self.selectedDateButton setTitle:[self.dateFormatter stringFromDate:datePicker.date] forState:UIControlStateNormal];;
    }
    [self dismissSemiModalViewWithCompletion:nil];
}

@end
