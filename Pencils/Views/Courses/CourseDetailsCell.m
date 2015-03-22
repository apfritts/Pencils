//
//  CourseDetailsCell.m
//  Pencils
//
//  Created by William Seo on 3/10/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "CourseDetailsCell.h"

@implementation CourseDetailsCell

- (void)awakeFromNib {
    self.courseDescriptionLabel.preferredMaxLayoutWidth = self.courseDescriptionLabel.frame.size.width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.courseDescriptionLabel.preferredMaxLayoutWidth = self.courseDescriptionLabel.frame.size.width;
}

@end
