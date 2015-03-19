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
#import "HeaderCell.h"
#import "MaterialCell.h"
#import "MaterialImporter.h"
#import "UserManager.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface TeacherCourseViewController () <HeaderCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) NSMutableArray *materials;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MaterialImporter *materialImporter;

@end

@implementation TeacherCourseViewController
static NSArray *__sectionHeaderTitles;

+(void)initialize {
    __sectionHeaderTitles = @[@"Course Description", @"Materials"];
}

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
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forCellReuseIdentifier:@"HeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MaterialCell" bundle:nil] forCellReuseIdentifier:@"MaterialCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.course.user == [UserManager currentUser]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditTap)];
    }
    
    self.tableView.sectionHeaderHeight = 48.0;
}

-(void)onEditTap {
    [NavigationUtility navigateToEditTeacherCourse:self.course];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
    HeaderCell *header = [self.tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    header.section = section;
    if (section == 0) {
        header.headerLabel.text = @"Course Description";
        [header.headerButton setTitle:@"View Global Courses" forState:UIControlStateNormal];
    } else if (section == 1) {
        header.headerLabel.text = @"Materials";
        [header.headerButton setTitle:@"Import" forState:UIControlStateNormal];
    }
    header.delegate = self;
    return header;
}

-(void)headerCellButtonTap:(HeaderCell *)headerCell {
    switch (headerCell.section) {
        case 0: {
            [NavigationUtility navigateToGlobalCourse:self.course.parent];
            break;
        }
        case 1: {
            self.materialImporter = [[MaterialImporter alloc] initWithCourse:self.course andParent:self andCompletion:^(Material *material, NSError *error) {
                NSLog(@"MaterialImporter complete!");
            }];
            [self.materialImporter execute:headerCell.headerButton];
            break;
        }
        default:
            break;
    }
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
            if (!cell.globalCourse) {
                cell.globalCourseButton.hidden=YES;
            }
            return cell;
            break;
        }
        default: {
            MaterialCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MaterialCell"];
            Material *material = [[Material alloc] init];
            material.title = @"Material Title";
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
        default: {
            [NavigationUtility navigateToMaterial:nil];
            break;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
