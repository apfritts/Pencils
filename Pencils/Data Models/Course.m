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

#import "Course.h"

@interface Course()

@property (strong, nonatomic) PFObject *_persistance;

@end

@implementation Course

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.courseDescription = dictionary[@"description"];
        self.start = dictionary[@"start"];
        self.end = dictionary[@"end"];
        self.deleted = dictionary[@"deleted"];
        self.parent = dictionary[@"parent"];
        self.user = dictionary[@"user"];
        self.materials = [dictionary[@"materials"] array];
        self._persistance = [PFObject objectWithClassName:@"Course"];
    }
    return self;
}

-(instancetype)initWithParseObject:(PFObject *)pfObject {
    self = [super init];
    if (self) {
        self._persistance = pfObject;
        self.name = [pfObject objectForKey:@"name"];
        self.courseDescription = [pfObject objectForKey:@"description"];
        self.start = [pfObject objectForKey:@"start"];
        self.end = [pfObject objectForKey:@"end"];
        self.deleted = [pfObject objectForKey:@"deleted"];
        if ([pfObject[@"parent"] isDataAvailable]) {
            self.parent = [[Course alloc] initWithParseObject:[pfObject objectForKey:@"parent"]];
        }
        if ([pfObject[@"user"] isDataAvailable]) {
            self.user = [[User alloc] initWithParseObject:[pfObject objectForKey:@"user"]];
        }
//        if ([pfObject[@"materials"] isDataAvailable]) {
            self.materials = [[NSArray alloc] init];
//        }
    }
    return self;
}

-(NSArray *)validate {
    NSMutableArray *validate = [NSMutableArray array];
    if (self.name.length == 0) {
        [validate addObject:@"A course name is required."];
    }
    if (self.courseDescription.length == 0) {
        [validate addObject:@"A course description is required."];
    }
    if (self.parent != nil) {
        if (!self.start) {
            [validate addObject:@"You have to select a start date!"];
        }
        if (!self.end) {
            [validate addObject:@"You have to select an end date!"];
        }
        if (self.start && self.end && self.start > self.end) {
            [validate addObject:@"The start date is after the end date.\n\nYou cannot start the class after it ended!"];
        }
    }
    return validate;
}

-(void)saveWithCompletion:(void (^)(NSError *))completion {
    NSArray *validate = [self validate];
    if (validate.count > 0) {
        completion([[NSError alloc] initWithDomain:@"com.box.Pencils" code:1 userInfo:@{@"validate": validate}]);
        return;
    }
    self._persistance[@"name"] = self.name;
    self._persistance[@"description"] = self.courseDescription;
    if (self.start) {
        self._persistance[@"start"] = self.start;
    }
    if (self.end) {
        self._persistance[@"end"] = self.end;
    }
    if (self.deleted) {
        self._persistance[@"deleted"] = self.deleted;
    }
    if (self.parent) {
        self._persistance[@"parent"] = [self.parent persistance];
    }
    if (self.user) {
        self._persistance[@"user"] = [self.user persistance];
    }
    [self._persistance saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(error);
    }];
}

-(PFObject *)persistance {
    return self._persistance;
}

@end
