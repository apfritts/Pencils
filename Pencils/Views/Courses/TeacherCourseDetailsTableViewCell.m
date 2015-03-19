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
    self.descriptionLabel.preferredMaxLayoutWidth = self.descriptionLabel.frame.size.width;
    NSLog(@"%f", self.descriptionLabel.preferredMaxLayoutWidth);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.descriptionLabel.preferredMaxLayoutWidth = self.descriptionLabel.frame.size.width;
}

@end
