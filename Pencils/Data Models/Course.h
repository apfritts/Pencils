//
//  Course.h
//  Pencils
//
//  Created by AP Fritts on 3/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *deleted;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
