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

#import "Material.h"

@interface Material()

@property (strong, nonatomic) PFObject *persistance;

@end

@implementation Material

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[@"title"];
        self.persistance = [PFObject objectWithClassName:@"Material"];
    }
    return self;
}

-(instancetype)initWithParseObject:(PFObject *)pfObject {
    self = [super init];
    if (self) {
        self.persistance = pfObject;
        self.title = pfObject[@"title"];
    }
    return self;
}

-(void)saveWithCompletion:(void (^)(NSError *error))completion {
    self.persistance[@"title"] = self.title;
    [self.persistance saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(error);
    }];
}

@end
