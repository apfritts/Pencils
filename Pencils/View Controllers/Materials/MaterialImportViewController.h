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

@interface MaterialImportViewController : UIDocumentPickerViewController

-(instancetype)initWithCourse:(Course *)course andCompletion:(void (^)(Material *material, NSError *error))completion;

@end
