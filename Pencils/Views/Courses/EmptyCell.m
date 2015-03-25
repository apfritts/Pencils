//
//  EmptyCell.m
//  Pencils
//
//  Created by AP Fritts on 3/25/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "EmptyCell.h"

@interface EmptyCell()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation EmptyCell

- (void)setMessage:(NSString *)message {
    self.messageLabel.text = message;
}

@end
