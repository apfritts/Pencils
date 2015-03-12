//
//  PreviewViewController.m
//  Pencils
//
//  Created by Thuy Nguyen on 3/11/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "PreviewViewController.h"
#import "BoxClient.h"

@interface PreviewViewController () <UIDocumentInteractionControllerDelegate>
- (IBAction)onPreview:(id)sender;
@property UIDocumentInteractionController *documentInteractionController;
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)onPreview:(id)sender {
    NSURL *URL = [BoxClient getPreviewFile:@"37e8f5fb241e48068293c14f8fdc66d9"]; //[[NSBundle mainBundle] URLForResource:@"pdf-test" withExtension:@"pdf"];
    
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Preview PDF
        [self.documentInteractionController presentPreviewAnimated:YES];
    }
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}
@end
