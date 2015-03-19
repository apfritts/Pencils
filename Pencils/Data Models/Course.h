/**
 * Purpose:
 *
 * Copyright 2015 Pencils Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

@interface Course : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *courseDescription;
@property (strong, nonatomic) NSDate *deleted;
@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
@property (strong, nonatomic) Course *parent;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) User *owner;
@property (strong, nonatomic) NSArray *materials;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(instancetype)initWithParseObject:(PFObject *)pfObject;
-(NSArray *)validate;
-(void)saveWithCompletion:(void (^)(NSError *error))completion;
-(PFObject *)persistance;
-(NSString *)datesTaught;

@end
