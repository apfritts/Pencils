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
    [self layoutSubviews];
}

- (void)layoutSubviews {
    CGSize sizeThatFitsTextView = [self.courseDescriptionTextView sizeThatFits:CGSizeMake(self.courseDescriptionTextView.frame.size.width, MAXFLOAT)];
    self.textViewHeightConstraint.constant = sizeThatFitsTextView.height;
    [super layoutSubviews];
}

@end
