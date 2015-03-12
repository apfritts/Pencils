//
//  ActionViewController.m
//  Share Material
//
//  Created by AP Fritts on 3/11/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "ActionViewController.h"
#import "CourseTableViewCell.h"
#import "CourseManager.h"
#import "User.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get the item[s] we're handling from the extension context.
    NSArray *fileTypes = @[
                           (NSString *)kUTTypeFileURL,
                           (NSString *)kUTTypePDF
                           ];
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        self.titleLabel.text = [NSString stringWithFormat:@"Items: %lu", (unsigned long)item.attachments.count];
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                    if(item) {
                        // do something with this
                    }
                }];
            }
        }
    }
    
    User *user = [[User alloc] init];
    user.firstName = @"AP";
    self.titleLabel.text = user.firstName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
