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

#import "MaterialManager.h"

@implementation MaterialManager

+(void)createMaterialWithDictionary:(NSDictionary *)dictionary withCompletion:(void (^)(Material *material, NSError *error))completion {
    Material *material = [[Material alloc] initWithDictionary:dictionary];
    [material saveWithCompletion:^(NSError *error) {
        if (completion) {
            completion(material, error);
        }
    }];
}

+(void)listMaterialForCourse:(Course *)course withCompletion:(void (^)(NSArray *materials, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Material"];
    [query whereKey:@"course" equalTo:[course persistance]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *materials = [NSMutableArray array];
        if (objects) {
            for (PFObject *object in objects) {
                Material *material = [[Material alloc] initWithParseObject:object];
                material.course = course;
                [materials addObject:material];
            }
        }
        if (completion != nil) {
            completion(materials, error);
        }
    }];
}

+(void)retrieveMaterialById:(NSString *)materialId withCompletion:(void (^)(Material *material, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Material"];
    [query includeKey:@"course"];
    [query getObjectInBackgroundWithId:materialId block:^(PFObject *object, NSError *error) {
        Material *material = nil;
        if (object) {
            material = [[Material alloc] initWithParseObject:object];
        }
        if (completion) {
            completion(material, error);
        }
    }];
}

+(void)searchForMaterialInCourse:(Course *)course byTitle:(NSString *)title withCompletion:(void (^)(NSArray *, NSError *))completion {
    NSArray *materials = nil;
    if (completion != nil) {
        completion(materials, nil);
    }
}

@end
