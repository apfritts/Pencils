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
#import "CourseDetailsCell.h"
#import "PersonCell.h"
#import "MaterialCell.h"
#import "MaterialImporter.h"
#import "HeaderCell.h"
#import "UserManager.h"
#import "CourseManager.h"

@interface GlobalCourseViewController () <HeaderCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) MaterialImporter *materialImporter;

@end

@implementation GlobalCourseViewController
static NSArray *__sectionHeaderTitles;

+(void)initialize {
    __sectionHeaderTitles = @[
                              @"Course Description",
                              @"Teachers",
                              @"Materials"
                              ];
}

-(instancetype)initWithGlobalCourse:(Course *)globalCourse {
    self = [super init];
    if (self) {
        self.course = globalCourse;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [CourseManager retreiveCourseById:self.course.objectId withCompletion:^(Course *course, NSError *error) {
        self.course = course;
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Global %@", self.course.name];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSMutableArray *rightBarButtons = [[NSMutableArray alloc] init];
    if (self.course.owner != [UserManager currentUser]) {
        UIBarButtonItem *editCourseButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEditButton)];
        [rightBarButtons addObject:editCourseButton];
    }
    UIBarButtonItem *teachCourseButton = [[UIBarButtonItem alloc] initWithTitle:@"Teach" style:UIBarButtonItemStylePlain target:self action:@selector(onTeachCourseButton)];
    [rightBarButtons addObject:teachCourseButton];
    self.navigationItem.rightBarButtonItems = rightBarButtons;
    
    [UserManager listUsersForGlobalCourse:self.course withCompletion:^(NSArray *users, NSError *error) {
        self.users = [[NSArray alloc] initWithArray:users];
        [self.tableView reloadData];
    }];
    [self.course retrieveMaterials:^(NSError *error) {
        [self.tableView reloadData];
    }];

    [self.tableView registerNib:[UINib nibWithNibName:@"CourseDetailsCell" bundle:nil] forCellReuseIdentifier:@"CourseDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"PersonCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MaterialCell" bundle:nil] forCellReuseIdentifier:@"MaterialCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forCellReuseIdentifier:@"HeaderCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 45;
    self.tableView.sectionHeaderHeight = 48.0;
}

- (void)onEditButton {
    [NavigationUtility navigateToEditTeacherCourse:self.course];
}

- (void)onTeachCourseButton {
    [NavigationUtility navigateToTeachCourse:self.course];
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
            CourseDetailsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CourseDetailsCell"];
            return cell.contentView.frame.size.height;
        }
        default:
            return 44;
            break;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderCell *header = [self.tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    [header.headerLabel setText:__sectionHeaderTitles[section]];
    if (section == 2) {
        [header.headerButton setTitle:@"Add Material" forState:UIControlStateNormal];
        header.delegate = self;
    } else {
        header.headerButton.hidden = YES;
    }
    return header;
}

-(void)headerCellButtonTap:(HeaderCell *)headerCell {
    self.materialImporter = [[MaterialImporter alloc] initWithCourse:self.course andParent:self andCompletion:^(Material *material, NSError *error) {
        [self.tableView reloadData];
    }];
    [self.materialImporter execute:headerCell.headerButton];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            CourseDetailsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CourseDetailsCell"];
            cell.courseDescriptionTextView.text = self.course.courseDescription;
            cell.course = self.course;
            [cell.courseDescriptionTextView sizeToFit];
            return cell;
            break;
        }
        case 1: {
            PersonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
            User *user = self.users[indexPath.row];
            cell.teacherLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
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
            [NavigationUtility navigateToTeacherCourse:self.course];
            break;
        }
        default: {
            break;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
