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

#import "SignupViewController.h"
#import "NavigationUtility.h"
#import "UserManager.h"

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignupViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< Login" style:UIBarButtonItemStylePlain target:self action:@selector(onBackToLoginTap)];
}

-(void)onBackToLoginTap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUpTap:(id)sender {
    [NavigationUtility progressBeginInView:self.view];
    [UserManager signUpWithFirstName:self.firstNameField.text andLastName:self.lastNameField.text andEmail:self.emailField.text andPassword:self.passwordField.text andCompletion:^(User *user, NSError *error) {
        [NavigationUtility progressStop];
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            [NavigationUtility login];
        }
    }];
}

@end
