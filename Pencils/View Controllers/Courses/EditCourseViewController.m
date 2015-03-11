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

#import "EditCourseViewController.h"
#import "ColorUtility.h"
#import "NavigationUtility.h"
#import <THCalendarDatePicker/THDatePickerViewController.h>

@interface EditCourseViewController () <THDatePickerDelegate>

@property (strong, nonatomic) Course *course;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *startPicker;
@property (weak, nonatomic) IBOutlet UIButton *endPicker;

@property (strong, nonatomic) THDatePickerViewController *datePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) UIButton *selectedDateButton;
@property (assign, nonatomic) enum {START_DATE = 0, END_DATE = 1} selectedDate;

@end

@implementation EditCourseViewController

-(instancetype)initWithCourse:(Course *)course {
    self = [super init];
    if (self) {
        self.course = course;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup the navigation bar
    self.title = @"Edit Course";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneTap)];
    
    // Define the date formatter
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    // Setup the course fields
    self.nameField.text = self.course.name;
    self.descriptionField.text = self.course.description;
    [self.startPicker setTitle:[self.dateFormatter stringFromDate:self.course.start] forState:UIControlStateNormal];
    [self.endPicker setTitle:[self.dateFormatter stringFromDate:self.course.end] forState:UIControlStateNormal];
    
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

-(void)onDoneTap {
    // @TODO: Move to data model
    if (!self.course.start) {
        [[[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"You have to select a start date!" delegate:nil cancelButtonTitle:@"Fix it" otherButtonTitles:nil] show];
        return;
    }
    if (!self.course.end) {
        [[[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"You have to select an end date!" delegate:nil cancelButtonTitle:@"Fix it" otherButtonTitles:nil] show];
        return;
    }
    if (self.course.start > self.course.end) {
        [[[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"The start date is after the end date.\n\nYou cannot start the class after it ended!" delegate:nil cancelButtonTitle:@"Whoops!" otherButtonTitles:nil] show];
        return;
    }
    
    // Create the course
    [NavigationUtility progressBegin];
    [self.course saveWithCompletion:^(NSError *error) {
        [NavigationUtility progressStop];
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.debugDescription delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
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
        self.datePicker.date = self.course.start;
    } else {
        self.datePicker.date = self.course.end;
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
            self.course.start = datePicker.date;
        } else {
            self.course.end = datePicker.date;
        }
        [self.selectedDateButton setTitle:[self.dateFormatter stringFromDate:datePicker.date] forState:UIControlStateNormal];
    }
    [self dismissSemiModalViewWithCompletion:nil];
}

@end
