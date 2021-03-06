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
#import "Course.h"

@interface Material : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) PFFile *file;
@property (strong, nonatomic) NSString *boxFileId;
@property (strong, nonatomic) Course *course;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(instancetype)initWithParseObject:(PFObject *)pfObject;
-(NSArray *)validate;
-(void)saveWithCompletion:(void (^)(NSError *error))completion;
-(void)retrieveFileWithCompletion:(void (^)(NSError *error))completion;
-(PFObject *)persistance;

@end
