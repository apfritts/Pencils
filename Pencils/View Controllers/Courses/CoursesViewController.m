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
#import "CourseTableViewCell.h"
#import "NavigationUtility.h"
#import "CourseManager.h"
#import <FontAwesome+iOS/UIImage+FontAwesome.h>

@interface CoursesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *courses;
@property (assign, nonatomic) BOOL isListOfGlobalCourses;

@end

@implementation CoursesViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Courses";
        [self.tabBarItem setImage:[UIImage imageWithIcon:@"icon-book" backgroundColor:[ColorUtility transparent] iconColor:[ColorUtility primaryColor] iconScale:1.0 andSize:CGSizeMake(30.0, 30.0)]];
    }
    return self;
}

-(instancetype)initWithGlobalCourses:(NSArray *)courses {
    self = [self init];
    if (self) {
        self.courses = courses;
        self.isListOfGlobalCourses = YES;
    }
    return self;
}

-(instancetype)initWithTeacherCourses:(NSArray *)courses {
    self = [self init];
    if (self) {
        self.courses = courses;
        self.isListOfGlobalCourses = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.courses == nil) {
        // This is THE top level list of global classes
        [CourseManager listGlobalCoursesWithCompletion:^(NSArray *courses, NSError *error) {
            if (!error) {
                self.courses = courses;
                [self.tableView reloadData];
            }
        }];
        
        // @TODO: We need to cleanup all of these inits/viewDidLoad stuff
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(onCreateTap)];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"CourseCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)onCreateTap {
    [NavigationUtility navigateToCourseCreate];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
    Course *course = self.courses[indexPath.row];
    cell.courseLabel.text = course.name;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courses.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isListOfGlobalCourses) {
        [NavigationUtility navigateToGlobalCourse:self.courses[indexPath.row]];
    } else {
        [NavigationUtility navigateToTeacherCourse:self.courses[indexPath.row]];
    }
}

@end
