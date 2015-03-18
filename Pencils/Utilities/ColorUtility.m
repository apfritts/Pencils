//
//  ColorUtility.m
//  Pencils
//
//  Created by AP Fritts on 3/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "ColorUtility.h"

@implementation ColorUtility
static UIColor *__backgroundColor;
static UIColor *__primaryColor;
static UIColor *__shadedBackground;
static UIColor *__tintColor;
static UIColor *__transparentColor;

/*
 * We initialize once to reduce overhead in the future.
 */
+(void)initialize {
    __backgroundColor = [UIColor colorWithRed:(36/255.0) green:(34/255.0) blue:(31/255.0) alpha:1.0];
    __primaryColor = [UIColor colorWithRed:(94/255.0) green:(124/255.0) blue:(136/255.0) alpha:1.0];
    __shadedBackground = [UIColor colorWithRed:(54/255.0) green:(63/255.0) blue:(69/255.0) alpha:0.5];
    __tintColor = [UIColor colorWithRed:(254/255.0) green:(180/255.0) blue:(28/255.0) alpha:1.0];
    __transparentColor = [UIColor clearColor];
}

+(UIColor *)backgroundColor {
    return __backgroundColor;
}

+(UIColor *)primaryColor {
    return __primaryColor;
}

+(UIColor *)shadedBackground {
    return __shadedBackground;
}

+(UIColor *)tintColor {
    return __tintColor;
}

+(UIColor *)transparent {
    return __transparentColor;
}

@end
