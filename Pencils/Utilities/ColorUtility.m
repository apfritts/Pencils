//
//  ColorUtility.m
//  Pencils
//
//  Created by AP Fritts on 3/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "ColorUtility.h"

@implementation ColorUtility

+(UIColor *)primaryColor {
    return [UIColor redColor];
}

+(UIColor *)transparent {
    return [UIColor clearColor];
}

+(UIColor *)shadedBackground {
    return [UIColor colorWithWhite:0.3 alpha:0.5];
}

@end
