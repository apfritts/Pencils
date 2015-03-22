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

#import "HeaderCell.h"
#import "MaterialCell.h"
#import "MaterialManager.h"
#import "MaterialImporter.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SearchUtility.h"
#import "CourseDetailsCell.h"
#import "UserManager.h"

@interface TeacherCourseViewController () <HeaderCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) NSArray *materials;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MaterialImporter *materialImporter;
@property (strong, nonatomic) SearchUtility *materialSearch;

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseDetailsCell" bundle:nil] forCellReuseIdentifier:@"CourseDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forCellReuseIdentifier:@"HeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MaterialCell" bundle:nil] forCellReuseIdentifier:@"MaterialCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.course.user == [UserManager currentUser]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditTap)];
    }
    
    [self.course addObserver:self forKeyPath:@"courseDescription" options:0 context:NULL];
    
    self.tableView.sectionHeaderHeight = 48.0;
    
    self.materialSearch = [[SearchUtility alloc] initWithTableView:self.tableView type:@"materials" keyPath:@"title" data:self.materials];
    
    [NavigationUtility progressBeginInView:self.view];
    [MaterialManager listMaterialForCourse:self.course withCompletion:^(NSArray *materials, NSError *error) {
        [NavigationUtility progressStop];
        self.materials = materials;
        [self.materialSearch updateData:self.materials];
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.tableView reloadData];
}

-(void)onEditTap {
    [NavigationUtility navigateToEditTeacherCourse:self.course];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            return 90;
            break;
        }
        case 1:
            return UITableViewAutomaticDimension;
            break;
        default:
            return 44;
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            HeaderCell *header = [self.tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
            header.section = section;
            header.headerLabel.text = @"Course Description";
            [header.headerButton setTitle:@"Parent Course" forState:UIControlStateNormal];
            header.delegate = self;
            return header;
        }
        case 2: {
            return self.materialSearch.searchBarView;
        }
        case 1: {
            HeaderCell *header = [self.tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
            header.section = section;
            header.headerLabel.text = @"Materials";
            [header.headerButton setTitle:@"Import" forState:UIControlStateNormal];
            header.delegate = self;
            return header;
        }
    }
    return nil;
}

-(void)headerCellButtonTap:(HeaderCell *)headerCell {
    switch (headerCell.section) {
        case 0: {
            [NavigationUtility navigateToGlobalCourse:self.course.parent];
            break;
        }
        case 1: {
            self.materialImporter = [[MaterialImporter alloc] initWithCourse:self.course andParent:self andCompletion:^(Material *material, NSError *error) {
                NSMutableArray *materials = [NSMutableArray arrayWithArray:self.materials];
                [materials addObject:material];
                self.materials = materials;
                [self.tableView reloadData];
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
        case 1:
            return 0;
        case 2: {
            if (self.materialSearch.filteredData) {
                return self.materialSearch.filteredData.count;
            } else {
                return self.materials.count;
            }
        }
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            CourseDetailsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CourseDetailsCell"];
            cell.courseDescriptionLabel.text = self.course.courseDescription;
            cell.course = self.course;
            return cell;
            break;
        }
        case 2: {
            MaterialCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MaterialCell"];
            Material *material = self.materialSearch.filteredData ? self.materialSearch.filteredData[indexPath.row] : self.materials[indexPath.row];
            [cell setMaterial:material];
            return cell;
            break;
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            break;
        }
        default: {
            [NavigationUtility navigateToMaterial:self.materials[indexPath.row]];
            break;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)dealloc {
    [self.course removeObserver:self forKeyPath:@"courseDescription"];
}

@end
