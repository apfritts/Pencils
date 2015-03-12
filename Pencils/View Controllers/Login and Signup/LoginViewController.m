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
#import "SignupViewController.h"
#import "ConstraintUtility.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *pencilImage;
@property (weak, nonatomic) IBOutlet UIView *formContainerView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (assign, nonatomic) BOOL animationDidRun;

@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.formContainerView.alpha = 0.0;
    self.animationDidRun = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /* Mimic the AMEX app here:
     * 1) Once loaded, elevate the Pencil icon
     * 2) Have the shadow move a little
     */
    
    if (self.animationDidRun == NO) {
        self.animationDidRun = YES;
        [UIView animateWithDuration:1.0 animations:^{
            self.formContainerView.alpha = 1.0;
        }];
        [ConstraintUtility removeLayoutConstraint:NSLayoutAttributeCenterY betweenView:self.view andView:self.pencilImage];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pencilImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:50.0]];
        [UIView animateWithDuration:1.0 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

-(IBAction)loginTap:(id)sender {
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

-(IBAction)signUpTap:(id)sender {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[SignupViewController alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
