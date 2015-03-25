//
//  CourseDetailsCell.h
//  Pencils
//
//  Created by William Seo on 3/10/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "NavigationUtility.h"

@interface CourseDetailsCell : UITableViewCell

@property (strong, nonatomic) Course *course;
//@property (weak, nonatomic) IBOutlet UILabel *courseDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *courseDescriptionTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@end
