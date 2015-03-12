//
//  ConstraintUtility.m
//  Pencils
//
//  Created by AP Fritts on 3/12/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "ConstraintUtility.h"

@implementation ConstraintUtility

+(void)removeLayoutConstraint:(NSLayoutAttribute)attribute betweenView:(UIView *)firstView andView:(UIView *)secondView {
    [firstView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == secondView && constraint.firstAttribute == attribute) || (constraint.secondItem == secondView && constraint.secondAttribute == attribute)) {
            [firstView removeConstraint:constraint];
        }
    }];
}

@end
