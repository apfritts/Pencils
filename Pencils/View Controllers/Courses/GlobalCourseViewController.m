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
#import "MaterialCell.h"
#import "HeaderTableViewCell.h"

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
    
    UIBarButtonItem *editCourseButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEditButton)];
    self.navigationItem.rightBarButtonItem = editCourseButton;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GlobalCourseDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"GlobalCourseDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GlobalCourseTeacherTableViewCell" bundle:nil] forCellReuseIdentifier:@"GlobalCourseTeacherCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MaterialCell" bundle:nil] forCellReuseIdentifier:@"MaterialCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"HeaderCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)onEditButton {
    [NavigationUtility navigateToEditTeacherCourse:self.globalCourse];
}

- (void)onAddMaterialButton {
    NSLog(@"Add a course material!");
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            GlobalCourseDetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GlobalCourseDetailsCell"];
            CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height + 1;
            break;
        }
        default:
            return 44;
            break;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderTableViewCell *header = [self.tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];

    switch (section) {
        case 0:
            [header.headerLabel setText:@"Course Description"];
            break;
        case 1:
            [header.headerLabel setText:@"Teachers"];
            break;
        case 2: {
            [header.headerLabel setText:@"Materials"];
            [header.headerButton setTitle:@"Add" forState:UIControlStateNormal];
            break;
        }
        default:
            [header.headerLabel setText:@"Section"];
            break;
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            GlobalCourseDetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GlobalCourseDetailsCell"];
            cell.course = self.globalCourse;
            [cell.courseDescriptionLabel sizeToFit];
            cell.courseDescriptionLabel.text = self.globalCourse.courseDescription;
            return cell;
            break;
        }
        case 1: {
            GlobalCourseTeacherTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GlobalCourseTeacherCell"];
            cell.teacherLabel.text = @"Mattie";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            break;
        }
        default:{
            MaterialCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MaterialCell"];
            Material *material = [[Material alloc] init];
            material.title = @"Material";
            [cell setMaterial:material];
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
