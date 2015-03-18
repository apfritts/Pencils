//
//  MaterialImportViewController.h
//  Pencils
//
//  Created by AP Fritts on 3/11/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "Material.h"

@interface MaterialImporter : NSObject

-(instancetype)initWithCourse:(Course *)course andParent:(UIViewController *)parent andCompletion:(void (^)(Material *material, NSError *error))completion;
-(void)execute:(UIView *)popoverStart;

@end
