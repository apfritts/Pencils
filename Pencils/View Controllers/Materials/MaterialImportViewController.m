//
//  MaterialImportViewController.m
//  Pencils
//
//  Created by AP Fritts on 3/11/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "MaterialImportViewController.h"
#import "BoxClient.h"
#import "MaterialManager.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface MaterialImportViewController () <UIDocumentMenuDelegate, UIDocumentPickerDelegate>

@property (weak, nonatomic) Course *course;
@property (weak, nonatomic) UIViewController *parent;
@property (strong, nonatomic) NSArray *fileTypes;

@end

@implementation MaterialImportViewController
typedef void (^ImportCompletionHandler)(Material *material, NSError *error);
ImportCompletionHandler _completionHandler;

-(instancetype)initWithCourse:(Course *)course andParent:(UIViewController *)parent andCompletion:(void (^)(Material *, NSError *))completion {
    self = [super init];
    self.course = course;
    self.parent = parent;
    _completionHandler = completion;
    
    // @TODO: Get all file types from this list and put this somewhere central
    // https://developer.apple.com/library/ios/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259-SW1
    self.fileTypes = @[
                       (NSString*)kUTTypePDF,
                       @"com.microsoft.word.doc",
                       @"com.microsoft.excel.xls",
                       @"com.apple.keynote.key"
                       ];
    
    return self;
}

-(void)execute {
    UIDocumentMenuViewController *uiDocumentMenu = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:self.fileTypes inMode:UIDocumentPickerModeImport];
    uiDocumentMenu.delegate = self;
    [self.parent presentViewController:uiDocumentMenu animated:YES completion:nil];
}

# pragma mark - UIDocumentMenuDelegate

- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker {
     NSLog(@"documentPicker");
}

# pragma mark - UIDocumentPickerDelegate

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if ([url startAccessingSecurityScopedResource]) {
        NSLog(@"%@", [url absoluteString]);
        NSString *convertedFileId = [BoxClient convertFile:[url absoluteString]];
        NSDictionary *dictionary = @{
                                     @"title": convertedFileId,
                                     @"boxFileId": convertedFileId,
                                     @"course": self.course
                                     };
        [MaterialManager createMaterialWithDictionary:dictionary withCompletion:^(Material *material, NSError *error) {
            _completionHandler(material, error);
        }];
        [url stopAccessingSecurityScopedResource];
    } else {
        NSLog(@"ERROR");
    }
}

-(void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    _completionHandler(nil, nil);
}

@end
