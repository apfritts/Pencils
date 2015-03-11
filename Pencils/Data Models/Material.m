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

@property (strong, nonatomic) PFObject *_persistance;

@end

@implementation Material

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[@"title"];
        self.course = dictionary[@"course"];
        self._persistance = [PFObject objectWithClassName:@"Material"];
    }
    return self;
}

-(instancetype)initWithParseObject:(PFObject *)pfObject {
    self = [super init];
    if (self) {
        self._persistance = pfObject;
        self.title = pfObject[@"title"];
        if ([pfObject[@"course"] isDataAvailable]) {
            self.course = [[Course alloc] initWithParseObject:pfObject[@"course"]];
        }
    }
    return self;
}

-(NSArray *)validate {
    // @TODO: validate the model and return an array of issues if necessary
    return @[];
}

-(void)saveWithCompletion:(void (^)(NSError *error))completion {
    NSArray *validate = [self validate];
    if (validate.count > 0) {
        completion([[NSError alloc] initWithDomain:@"com.box.Pencils" code:1 userInfo:@{@"validate": validate}]);
        return;
    }
    self._persistance[@"title"] = self.title;
    self._persistance[@"course"] = [self.course persistance];
    [self._persistance saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(error);
    }];
}

-(PFObject *)persistance {
    return self._persistance;
}

@end
