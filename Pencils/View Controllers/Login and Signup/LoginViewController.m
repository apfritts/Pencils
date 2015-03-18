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

#import "LoginViewController.h"
#import "NavigationUtility.h"
#import "UserManager.h"
#import "ConstraintUtility.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *pencilImage;
@property (weak, nonatomic) IBOutlet UIView *formsContainerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *formLayoutToggle;

@property (weak, nonatomic) IBOutlet UIView *signupFieldsView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@property (weak, nonatomic) IBOutlet UIView *loginFieldsView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginTopConstraint;
@property (strong, nonatomic) NSLayoutConstraint *myLoginTopConstraint;

@property (assign, nonatomic) BOOL animationDidRun;

@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.formsContainerView.alpha = 0.0;
    self.animationDidRun = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self removeLoginConstraints];
    [self showLoginForm];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /* Mimic the AMEX app here:
     * 1) Once loaded, elevate the Pencil icon
     * 2) TODO: Have the shadow move a little
     */
    
    if (self.animationDidRun == NO) {
        self.animationDidRun = YES;
        [UIView animateWithDuration:1.0 animations:^{
            self.formsContainerView.alpha = 1.0;
        }];
        [ConstraintUtility removeLayoutConstraint:NSLayoutAttributeCenterY betweenView:self.view andView:self.pencilImage];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pencilImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50.0]];
        [UIView animateWithDuration:1.0 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)formLayoutToggled:(UISegmentedControl *)sender {
    [self removeLoginConstraints];
    if (sender.selectedSegmentIndex == 0) {
        [self showLoginForm];
    } else {
        [self showSignupForm];
    }
}

-(IBAction)actionButtonTap:(id)sender {
    [NavigationUtility progressBegin];
    [UserManager loginWithEmail:self.emailField.text andPassword:self.passwordField.text andCompletion:^(User *user, NSError *error) {
        [NavigationUtility progressStop];
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
        } else {
            [NavigationUtility login];
        }
    }];
}

-(void)removeLoginConstraints {
    NSLog(@"Login: I'm free!");
    if (self.loginTopConstraint) {
        [self.formsContainerView removeConstraint:self.loginTopConstraint];
    } else {
        [self.formsContainerView removeConstraint:self.myLoginTopConstraint];
    }
}

-(void)showLoginForm {
    NSLog(@"Login");
    self.myLoginTopConstraint = [NSLayoutConstraint constraintWithItem:self.loginFieldsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.formLayoutToggle attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0];
    [self.formsContainerView addConstraint:self.myLoginTopConstraint];
    [self.view layoutIfNeeded];
}

-(void)showSignupForm {
    NSLog(@"Signup");
    self.myLoginTopConstraint = [NSLayoutConstraint constraintWithItem:self.loginFieldsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.signupFieldsView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0];
    [self.formsContainerView addConstraint:self.myLoginTopConstraint];
    [self.view layoutIfNeeded];
}

@end
