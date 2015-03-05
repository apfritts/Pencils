//
//  Material.h
//  Pencils
//
//  Created by AP Fritts on 3/5/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Material : NSObject

@property (strong, nonatomic) NSString *title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
