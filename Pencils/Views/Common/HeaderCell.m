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

#import "HeaderCell.h"
#import "ColorUtility.h"

@interface HeaderCell()

@property (weak, nonatomic) IBOutlet UIView *divider;

@end

@implementation HeaderCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headerLabel setTintColor:[ColorUtility primaryColor]];
    self.headerButton.tintColor = [ColorUtility primaryColor];
    self.divider.backgroundColor = [ColorUtility shadedBackground];
}

- (IBAction)buttonTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(headerCellButtonTap:)]) {
        [self.delegate headerCellButtonTap:self];
    }
}

@end
