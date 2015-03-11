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

- (void)onAddMaterialButton {
    NSLog(@"Add a course material!");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            return 90;
            break;
        }
        default:
            return 44;
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1.0)];
    [view setBackgroundColor:[UIColor colorWithRed:204/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, tableView.frame.size.width, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    
    switch (section) {
        case 0:
            [label setText:@"Course Description"];
            break;
        case 1: {
            [label setText:@"Materials"];
            UIButton *addMaterialButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [addMaterialButton setFrame:CGRectMake((330.0), 5.0, 30.0, 30.0)];
            addMaterialButton.tag = section;
            addMaterialButton.hidden = NO;
            [addMaterialButton setBackgroundColor:[UIColor clearColor]];
            [addMaterialButton addTarget:self action:@selector(onAddMaterialButton) forControlEvents:UIControlEventTouchDown];
            [view addSubview:addMaterialButton];
            break;
        }
        default:
            [label setText:@"Section"];
            break;
    }
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
            cell.descriptionLabel.text = self.course.courseDescription;
            cell.course = self.course;
            cell.globalCourse = self.course.parent;
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
