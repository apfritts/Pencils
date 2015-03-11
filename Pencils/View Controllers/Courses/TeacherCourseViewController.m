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

#import "TeacherCourseViewController.h"
#import "TeacherCourseDetailsTableViewCell.h"
#import "TeacherMaterialsTableViewCell.h"

@interface TeacherCourseViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) NSMutableArray *materials;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TeacherCourseViewController

-(instancetype)initWithCourse:(Course *)course {
    self = [super init];
    if (self) {
        self.course = course;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@", self.course.name];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TeacherCourseDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"TeacherCourseDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TeacherMaterialsTableViewCell" bundle:nil] forCellReuseIdentifier:@"TeacherMaterialsCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        default:
            return 3;
            break;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            TeacherCourseDetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TeacherCourseDetailsCell"];
            cell.descriptionLabel.text = @"";
            cell.course = self.course;
            return cell;
            break;
        }
        default: {
            TeacherMaterialsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TeacherMaterialsCell"];
            cell.materialNameLabel.text = @"Syllabus";
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
        default: {
            //[NavigationUtility navigateToMaterialsView];
            break;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
