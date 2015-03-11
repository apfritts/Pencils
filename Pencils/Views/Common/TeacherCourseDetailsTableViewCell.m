//
//  TeacherCourseDetailsTableViewCell.m
//  Pencils
//
//  Created by William Seo on 3/10/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "TeacherCourseDetailsTableViewCell.h"

@implementation TeacherCourseDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onGlobalCourseButton:(id)sender {
    [NavigationUtility navigateToGlobalCourse:self.course.parent];
}
@end
