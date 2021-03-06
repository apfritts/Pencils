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

#import "MaterialCell.h"
#import <FontAwesome+iOS/NSString+FontAwesome.h>
#import <FontAwesome+iOS/UIFont+FontAwesome.h>

@interface MaterialCell()

@property (weak, nonatomic) IBOutlet UILabel *materialLabel;
@property (weak, nonatomic) IBOutlet UILabel *chevronRight;

@end

@implementation MaterialCell

-(void)updateMaterial:(Material *)material {
    self.material = material;
    self.materialLabel.text = material.title;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.chevronRight.font = [UIFont fontAwesomeFontOfSize:17.0];
    self.chevronRight.text = [NSString fontAwesomeIconStringForEnum:FAIconChevronRight];
}

@end
