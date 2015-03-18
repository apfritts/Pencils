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
#import <FontAwesome+iOS/UIImage+FontAwesome.h>

#import "ColorSchemesViewController.h"
#import "CourseManager.h"
#import "CourseTableViewCell.h"
#import "HeaderTableViewCell.h"
#import "RequestsTableViewCell.h"
#import "UserManager.h"

@interface HomeViewController () <HeaderTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *currentCourses;

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"CourseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"HeaderCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = 44.0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutTap)];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [NavigationUtility progressBegin];
    [CourseManager listCourseForUser:[UserManager currentUser] withCompletion:^(NSArray *courses, NSError *error) {
        self.currentCourses = courses;
        [self.tableView reloadData];
        [NavigationUtility progressStop];
    }];
}

-(void)onLogoutTap {
    [NavigationUtility logout];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderTableViewCell *header = [self.tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    header.headerLabel.text = @"Your Courses";
    [header.headerButton setTitle:@"View All" forState:UIControlStateNormal];
    header.delegate = self;
    return header;
}

-(void)headerTableViewCellButtonTap:(HeaderTableViewCell *)headerCell {
    Course *course = [[Course alloc] init];
    course.name = @"name of course";
    NSArray *courses = @[course, course, course, course, course, course, course, course, course];
    [NavigationUtility navigateToCourseListOf:courses];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentCourses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
    Course *course = self.currentCourses[indexPath.row];
    cell.courseLabel.text = course.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [NavigationUtility navigateToTeacherCourse:self.currentCourses[indexPath.row]];
}

- (IBAction)showColorSchemeTaps:(id)sender {
    [self presentViewController:[[ColorSchemesViewController alloc] init] animated:YES completion:nil];
}

@end
