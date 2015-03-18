//
//  ColorUtility.h
//  Pencils
//
//  Created by AP Fritts on 3/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

@interface ColorUtility : NSObject

+(UIColor *)backgroundColor;
+(UIColor *)primaryColor;
+(UIColor *)shadedBackground;
+(UIColor *)tintColor;
+(UIColor *)transparent;

@end
