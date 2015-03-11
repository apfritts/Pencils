//
//  TeacherMaterialsTableViewCell.h
//  Pencils
//
//  Created by William Seo on 3/10/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Material.h"

@interface TeacherMaterialsTableViewCell : UITableViewCell

@property (strong, nonatomic) Material *material;

@property (weak, nonatomic) IBOutlet UILabel *materialNameLabel;

@end
