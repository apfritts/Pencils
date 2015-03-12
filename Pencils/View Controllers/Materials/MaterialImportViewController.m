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
    NSArray *fileTypes = @[(NSString *)kUTTypePDF];
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
