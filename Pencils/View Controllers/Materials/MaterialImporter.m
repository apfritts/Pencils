//
//  MaterialImportViewController.m
//  Pencils
//
//  Created by AP Fritts on 3/11/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "MaterialImporter.h"
#import "BoxClient.h"
#import "MaterialManager.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface MaterialImporter () <UIDocumentMenuDelegate, UIDocumentPickerDelegate>

@property (weak, nonatomic) Course *course;
@property (weak, nonatomic) UIViewController *parent;
@property (strong, nonatomic) NSArray *fileTypes;

@end

@implementation MaterialImporter
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
                       (NSString*)kUTTypeItem,
                       (NSString*)kUTTypePresentation,
                       (NSString*)kUTTypeData
                       ];
    
    return self;
}

-(void)execute {
    UIDocumentMenuViewController *uiDocumentMenu = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:[self.fileTypes copy] inMode:UIDocumentPickerModeImport];
    uiDocumentMenu.delegate = self;
    [self.parent presentViewController:uiDocumentMenu animated:YES completion:nil];
}

# pragma mark - UIDocumentMenuDelegate

- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker {
    documentPicker.delegate = self;
    [self.parent presentViewController:documentPicker animated:YES completion:nil];
}

# pragma mark - UIDocumentPickerDelegate

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    NSString *convertedFileId = [BoxClient convertFile:[url absoluteString]];
    NSDictionary *dictionary = @{
                                 @"title": [url lastPathComponent],
                                 @"boxFileId": convertedFileId,
                                 @"course": self.course
                                 };
    [MaterialManager createMaterialWithDictionary:dictionary withCompletion:^(Material *material, NSError *error) {
        _completionHandler(material, error);
    }];
}

-(void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    _completionHandler(nil, nil);
}

@end
