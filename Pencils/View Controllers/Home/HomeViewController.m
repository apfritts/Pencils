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
#import "HeaderCell.h"
#import "RequestsTableViewCell.h"
#import "UserManager.h"

@interface HomeViewController () <HeaderCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *myCourses;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forCellReuseIdentifier:@"HeaderCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = 48.0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutTap)];
    
    [NavigationUtility progressBegin];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [CourseManager listCourseForUser:[UserManager currentUser] withCompletion:^(NSArray *courses, NSError *error) {
        self.myCourses = courses;
        NSDate *now = [NSDate date];
        self.currentCourses = [self.myCourses filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Course *course, NSDictionary *bindings) {
            return [now compare:course.start] != NSOrderedAscending && [now compare:course.end] != NSOrderedDescending;
        }]];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // @TODO: cache this and abstract it out - used in CoursesViewController too
    CourseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderCell *header = [self.tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    header.headerLabel.text = @"Courses you are teaching";
    [header.headerButton setTitle:@"View All" forState:UIControlStateNormal];
    header.delegate = self;
    return header;
}

-(void)headerCellButtonTap:(HeaderCell *)headerCell {
    [NavigationUtility navigateToCourseListOf:self.myCourses];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentCourses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
    Course *course = self.currentCourses[indexPath.row];
    cell.courseLabel.text = course.name;
    cell.descriptionLabel.text = [course datesTaught];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [NavigationUtility navigateToTeacherCourse:self.currentCourses[indexPath.row]];
}

- (IBAction)showColorSchemeTaps:(id)sender {
    [self presentViewController:[[ColorSchemesViewController alloc] init] animated:YES completion:nil];
}

@end
