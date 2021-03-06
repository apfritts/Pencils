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

#import "CoursesViewController.h"

#import "ColorUtility.h"
#import "Course.h"
#import "CourseManager.h"
#import "CourseTableViewCell.h"
#import <FontAwesome+iOS/UIImage+FontAwesome.h>
#import "GlobalCourseViewController.h"
#import "NavigationUtility.h"
#import "SearchUtility.h"
#import "UserManager.h"

@interface CoursesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *courses;
@property (strong, nonatomic) SearchUtility *searchUtility;

@end

@implementation CoursesViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Course Catalog";
        [self.tabBarItem setImage:[UIImage imageWithIcon:@"icon-book" backgroundColor:[ColorUtility transparent] iconColor:[ColorUtility primaryColor] iconScale:1.0 andSize:CGSizeMake(30.0, 30.0)]];
    }
    return self;
}

-(instancetype)initWithCourses:(NSArray *)courses {
    self = [self init];
    if (self) {
        self.courses = courses;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Setup the table
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"CourseCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Setup the search bar
    self.searchUtility = [[SearchUtility alloc] initWithTableView:self.tableView type:@"courses" keyPath:@"name" data:self.courses];
    self.tableView.tableHeaderView = [self.searchUtility searchBarView];
    
    // Setup global courses
    if (self.courses == nil) {
        // This is THE top level list of global classes
        [NavigationUtility progressBegin];
        [CourseManager listGlobalCoursesWithCompletion:^(NSArray *courses, NSError *error) {
            [NavigationUtility progressStop];
            if (error) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
            } else {
                self.courses = courses;
                if (self.searchUtility) {
                    [self.searchUtility updateData:self.courses];
                }
                [self.tableView reloadData];
            }
        }];
        
        // @TODO: We need to cleanup all of these inits/viewDidLoad stuff
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutTap)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onCreateTap)];
    } else {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}

-(void)onCreateTap {
    [NavigationUtility navigateToCourseCreate];
}

-(void)onLogoutTap {
    [NavigationUtility logout];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
    Course *course;
    if (self.searchUtility.filteredData) {
        course = self.searchUtility.filteredData[indexPath.row];
    } else {
        course = self.courses[indexPath.row];
    }
    cell.courseLabel.text = course.name;
    if (course.user == [UserManager currentUser]) {
        cell.descriptionLabel.text = [course datesTaught];
    } else {
        cell.descriptionLabel.text = course.courseDescription;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // @TODO: cache this and abstract it out - used in HomeViewController too
    CourseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchUtility.filteredData) {
        return self.searchUtility.filteredData.count;
    } else {
        return self.courses.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Course *course = self.courses[indexPath.row];
    if (course.parent == nil) {
        // Global Course View
        [NavigationUtility navigateToGlobalCourse:self.courses[indexPath.row]];
    } else {
        // Teache Specific Course View
        [NavigationUtility navigateToTeacherCourse:self.courses[indexPath.row]];
    }
}

@end
