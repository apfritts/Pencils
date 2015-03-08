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

#import "HomeViewController.h"
#import "ColorUtility.h"
#import "NavigationUtility.h"
#import "GlobalCourseViewController.h"
#import <FontAwesome+iOS/UIImage+FontAwesome.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Home";
        [self.tabBarItem setImage:[UIImage imageWithIcon:@"icon-home" backgroundColor:[ColorUtility transparent] iconColor:[ColorUtility primaryColor] iconScale:1.0 andSize:CGSizeMake(30.0, 30.0)]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
