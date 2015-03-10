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

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (IBAction)loginTap:(id)sender {
    [UserManager loginWithEmail:self.emailField.text andPassword:self.passwordField.text andCompletion:^(User *user, NSError *error) {
        [NavigationUtility login];
    }];
}

- (IBAction)signUpTap:(id)sender {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[SignupViewController alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
