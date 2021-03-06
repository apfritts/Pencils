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
#import "ColorUtility.h"
#import "NavigationUtility.h"
#import "UserManager.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *pencilImage;
@property (weak, nonatomic) IBOutlet UIView *formsContainerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *formLayoutToggle;

@property (weak, nonatomic) IBOutlet UIView *signupFieldsView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@property (weak, nonatomic) IBOutlet UIView *loginFieldsView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tempLoginViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tempPencilYConstraint;
@property (strong, nonatomic) NSLayoutConstraint *loginViewTopConstraint;

@property (assign, nonatomic) BOOL doFirstLoad;

@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.formsContainerView.alpha = 0.0;
    self.doFirstLoad = YES;
    
    self.view.backgroundColor = [ColorUtility backgroundColor];
    self.firstNameLabel.textColor = [ColorUtility primaryColor];
    self.lastNameLabel.textColor = [ColorUtility primaryColor];
    self.emailLabel.textColor = [ColorUtility primaryColor];
    self.passwordLabel.textColor = [ColorUtility primaryColor];
    self.formLayoutToggle.backgroundColor = [ColorUtility backgroundColor];
    self.formLayoutToggle.tintColor = [ColorUtility tintColor];
    self.actionButton.tintColor = [ColorUtility tintColor];
    self.loginFieldsView.backgroundColor = [ColorUtility backgroundColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.doFirstLoad) {
        [self.formsContainerView removeConstraint:self.tempLoginViewConstraint];
        [self showLoginForm];
        [self.view layoutIfNeeded];
        [ColorUtility transparentTransitionForView:self.gradientView];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /* Mimic the AMEX app here:
     * 1) Once loaded, elevate the Pencil icon
     * 2) TODO: Have the shadow move a little
     */
    
    if (self.doFirstLoad) {
        self.doFirstLoad = NO;
        [UIView animateWithDuration:1.0 animations:^{
            self.formsContainerView.alpha = 1.0;
        }];
        
        [self.view removeConstraint:self.tempPencilYConstraint];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pencilImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.formsContainerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0]];
        [UIView animateWithDuration:1.0 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)formLayoutToggled:(id)sender {
    [self removeLoginConstraints];
    if (self.formLayoutToggle.selectedSegmentIndex == 0) {
        [self showLoginForm];
    } else {
        [self showSignupForm];
    }
    [UIView animateWithDuration:0.7 animations:^{
        [self.view layoutIfNeeded];
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstNameField) {
        [self.lastNameField becomeFirstResponder];
    } else if (textField == self.lastNameField) {
        [self.emailField becomeFirstResponder];
    } else if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self actionButtonTap:nil];
    }
    return YES;
}

-(IBAction)actionButtonTap:(id)sender {
    [NavigationUtility progressBegin];
    if (self.formLayoutToggle.selectedSegmentIndex == 0) {
        [UserManager loginWithEmail:self.emailField.text andPassword:self.passwordField.text andCompletion:^(User *user, NSError *error) {
            [NavigationUtility progressStop];
            if (error) {
                [[[UIAlertView alloc] initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
                [self.emailField becomeFirstResponder];
            } else {
                [NavigationUtility login];
            }
        }];
    } else {
        [UserManager signUpWithFirstName:self.firstNameField.text andLastName:self.lastNameField.text andEmail:self.emailField.text andPassword:self.passwordField.text andCompletion:^(User *user, NSError *error) {
            [NavigationUtility progressStop];
            if (error) {
                [[[UIAlertView alloc] initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil] show];
                [self.firstNameField becomeFirstResponder];
            } else {
                [NavigationUtility login];
            }
        }];
    }
}

-(void)removeLoginConstraints {
    [self.formsContainerView removeConstraint:self.loginViewTopConstraint];
}

-(void)showLoginForm {
    self.loginViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.loginFieldsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.formLayoutToggle attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0];
    [self.formsContainerView addConstraint:self.loginViewTopConstraint];    [self.actionButton setTitle:@"Login" forState:UIControlStateNormal];
}

-(void)showSignupForm {
    self.loginViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.loginFieldsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.signupFieldsView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0];
    [self.formsContainerView addConstraint:self.loginViewTopConstraint];
    [self.actionButton setTitle:@"Signup" forState:UIControlStateNormal];
}

@end
