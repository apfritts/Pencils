//
//  EmptyListTableViewCell.m
//  Pencils
//
//  Created by AP Fritts on 3/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "EmptyListTableViewCell.h"
#import "ColorUtility.h"
#import <FontAwesome+iOS/UIImage+FontAwesome.h>

@interface EmptyListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *emptyImage;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@end

@implementation EmptyListTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.emptyImage.image = [UIImage imageWithIcon:@"icon-heart-empty" backgroundColor:[ColorUtility transparent] iconColor:[ColorUtility primaryColor] iconScale:1.0 andSize:CGSizeMake(100.0, 100.0)];
}

@end
