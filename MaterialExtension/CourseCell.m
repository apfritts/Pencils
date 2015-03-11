//
//  CourseCell.m
//  Pencils
//
//  Created by AP Fritts on 3/10/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "CourseCell.h"

@interface CourseCell()

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;

@end

@implementation CourseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
