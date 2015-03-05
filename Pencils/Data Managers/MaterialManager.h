//
//  MaterialManager.h
//  Pencils
//
//  Created by AP Fritts on 3/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "Material.h"

@interface MaterialManager : NSObject

+(Material *)createMaterialWithDictionary:(NSDictionary *)dictionary;
+(NSArray *)listMaterialForCourse:(Course *)course;
+(Material *)retrieveMaterialById:(NSInteger)materialId;
+(NSArray *)searchForMaterialInCourse:(Course *)course byTitle:(NSString *)title;

@end
