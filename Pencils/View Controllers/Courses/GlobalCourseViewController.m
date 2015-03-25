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
#import "CourseManager.h"
#import "EmptyCell.h"
#import "HeaderCell.h"
#import "MaterialCell.h"
#import "MaterialImporter.h"
#import "PersonCell.h"
#import "UserManager.h"

@interface GlobalCourseViewController () <HeaderCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) MaterialImporter *materialImporter;

@end

@implementation GlobalCourseViewController
static NSArray *__sectionHeaderTitles;

+(void)initialize {
    __sectionHeaderTitles = @[@"Course Description", @"Teachers", @"Materials"];
}

-(instancetype)initWithGlobalCourse:(Course *)globalCourse {
    self = [super init];
    if (self) {
        self.course = globalCourse;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Global %@", self.course.name];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseDetailsCell" bundle:nil] forCellReuseIdentifier:@"CourseDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EmptyCell" bundle:nil] forCellReuseIdentifier:@"EmptyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forCellReuseIdentifier:@"HeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MaterialCell" bundle:nil] forCellReuseIdentifier:@"MaterialCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"PersonCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 45;
    self.tableView.sectionHeaderHeight = 48.0;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSMutableArray *rightBarButtons = [[NSMutableArray alloc] init];
    if (self.course.owner != [UserManager currentUser]) {
        UIBarButtonItem *editCourseButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEditButton)];
        [rightBarButtons addObject:editCourseButton];
    }
    UIBarButtonItem *teachCourseButton = [[UIBarButtonItem alloc] initWithTitle:@"Teach" style:UIBarButtonItemStylePlain target:self action:@selector(onTeachCourseButton)];
    [rightBarButtons addObject:teachCourseButton];
    self.navigationItem.rightBarButtonItems = rightBarButtons;
    
    [self.course addObserver:self forKeyPath:@"courseDescription" options:0 context:NULL];
    
    [NavigationUtility progressBeginInView:self.view];
    [UserManager listUsersForGlobalCourse:self.course withCompletion:^(NSArray *users, NSError *error) {
        self.users = [[NSArray alloc] initWithArray:users];
        [self.tableView reloadData];
        [self shouldStopProgress];
    }];
    [self.course retrieveMaterials:^(NSError *error) {
        [self.tableView reloadData];
        [self shouldStopProgress];
    }];
}

- (void)onEditButton {
    [NavigationUtility navigateToEditTeacherCourse:self.course];
}

- (void)onTeachCourseButton {
    [NavigationUtility navigateToTeachCourse:self.course];
}

-(void)shouldStopProgress {
    if (self.users != nil && self.course.materials != nil) {
        [NavigationUtility progressStop];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.users.count || 1;
        case 2:
            return self.course.materials.count || 1;
        default:
            return 3;
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
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderCell *header = [self.tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    [header.headerLabel setText:__sectionHeaderTitles[section]];
    if (section == 2) {
        [header.headerButton setTitle:@"Import" forState:UIControlStateNormal];
        header.delegate = self;
    } else {
        header.headerButton.hidden = YES;
    }
    return header;
}

-(void)headerCellButtonTap:(HeaderCell *)headerCell {
    self.materialImporter = [[MaterialImporter alloc] initWithCourse:self.course andParent:self andCompletion:^(Material *material, NSError *error) {
        if (!error) {
            NSMutableArray *materials = [NSMutableArray arrayWithArray:self.course.materials];
            [materials addObject:material];
            self.course.materials = materials;
            [self.tableView reloadData];
        }
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
        }
        case 1: {
            if (self.users.count == 0) {
                EmptyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
                [cell setMessage:@"No teachers...yet!"];
                return cell;
            } else {
                PersonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
                User *user = self.users[indexPath.row];
                cell.teacherLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
                return cell;
            }
        }
        default:{
            if (self.course.materials.count == 0) {
                EmptyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
                [cell setMessage:@"No materials...yet!"];
                return cell;
            } else {
                MaterialCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MaterialCell"];
                Material *material = self.course.materials[indexPath.row];
                [cell setMaterial:material];
                return cell;
            }
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

-(void)dealloc {
    [self.course removeObserver:self forKeyPath:@"courseDescription"];
}

@end
