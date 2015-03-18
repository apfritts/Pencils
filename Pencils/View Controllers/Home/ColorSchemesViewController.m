//
//  ColorSchemesViewController.m
//  Pencils
//
//  Created by AP Fritts on 3/17/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "ColorSchemesViewController.h"
#import "ColorUtility.h"

@interface ColorSchemesViewController ()

@property (weak, nonatomic) IBOutlet UIView *color1;
@property (weak, nonatomic) IBOutlet UIView *color2;
@property (weak, nonatomic) IBOutlet UIView *color3;
@property (weak, nonatomic) IBOutlet UIView *color4;
@property (weak, nonatomic) IBOutlet UIView *color5;

@end

@implementation ColorSchemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.color1.backgroundColor = [ColorUtility backgroundColor];
    self.color2.backgroundColor = [ColorUtility primaryColor];
    self.color3.backgroundColor = [ColorUtility shadedBackground];
    self.color4.backgroundColor = [ColorUtility tintColor];
    self.color5.backgroundColor = [ColorUtility transparent];
}

- (IBAction)closeTap:(id)sender {
    [self removeFromParentViewController];
}

@end
