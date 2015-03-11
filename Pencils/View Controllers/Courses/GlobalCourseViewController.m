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

#import "GlobalCourseViewController.h"
#import "GlobalCourseDetailsTableViewCell.h"
#import "GlobalCourseTeacherTableViewCell.h"

@interface GlobalCourseViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Course *globalCourse;

@end

@implementation GlobalCourseViewController

-(instancetype)initWithGlobalCourse:(Course *)globalCourse {
    self = [super init];
    if (self) {
        self.globalCourse = globalCourse;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@", self.globalCourse.name];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GlobalCourseDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"GlobalCourseDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GlobalCourseTeacherTableViewCell" bundle:nil] forCellReuseIdentifier:@"GlobalCourseTeacherCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;
            break;
        default:
            return 3;
            break;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            GlobalCourseDetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GlobalCourseDetailsCell"];
            cell.courseDescriptionLabel.text = @"";
            cell.course = self.globalCourse;
            return cell;
            break;
        }
        case 1: {
            GlobalCourseTeacherTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GlobalCourseTeacherCell"];
            cell.teacherLabel.text = @"Mattie";
            return cell;
            break;
        }
        default:{
            GlobalCourseTeacherTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GlobalCourseTeacherCell"];
            cell.teacherLabel.text = @"Louise";
            return cell;
            break;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            break;
        }
        case 1: {
            [NavigationUtility navigateToTeacherCourse:self.globalCourse];
            break;
        }
        default: {
            break;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
