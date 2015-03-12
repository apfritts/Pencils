//
//  ConstraintUtility.h
//  Pencils
//
//  Created by AP Fritts on 3/12/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConstraintUtility : NSObject

+(void)removeLayoutConstraint:(NSLayoutAttribute)attribute betweenView:(UIView *)firstView andView:(UIView *)secondView;

@end
