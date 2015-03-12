//
//  MaterialImportViewController.m
//  Pencils
//
//  Created by AP Fritts on 3/11/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "MaterialImportViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface MaterialImportViewController () <UIDocumentPickerDelegate>

@end

@implementation MaterialImportViewController
typedef void (^ImportCompletionHandler)(Material *material, NSError *error);
ImportCompletionHandler _completionHandler;

-(instancetype)initWithCourse:(Course *)course andCompletion:(void (^)(Material *material, NSError *error))completion {
    // @TODO: Get all file types from this list and put this somewhere central
    // https://developer.apple.com/library/ios/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259-SW1
    NSArray *fileTypes = @[
                           (NSString*)kUTTypePDF,
                           @"com.microsoft.word.doc",
                           @"com.microsoft.excel.xls",
                           @"com.apple.keynote.key"
                           ];
    self = [super initWithDocumentTypes:fileTypes inMode:UIDocumentPickerModeImport];
    if (self) {
        _completionHandler = completion;
    }
    return self;
}

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    _completionHandler(nil, nil);
}

-(void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    _completionHandler(nil, nil);
}

@end
