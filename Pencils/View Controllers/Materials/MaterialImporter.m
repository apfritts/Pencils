//
//  MaterialImportViewController.m
//  Pencils
//
//  Created by AP Fritts on 3/11/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "MaterialImporter.h"
#import "MaterialManager.h"
#import "NavigationUtility.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>

@interface MaterialImporter () <UIAlertViewDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate>

@property (strong, nonatomic) Course *course;
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

-(void)execute:(UIView *)popoverStart {
    UIDocumentMenuViewController *uiDocumentMenu = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:[self.fileTypes copy] inMode:UIDocumentPickerModeImport];
    uiDocumentMenu.delegate = self;
    uiDocumentMenu.popoverPresentationController.sourceView = popoverStart;
    [self.parent presentViewController:uiDocumentMenu animated:YES completion:nil];
}

# pragma mark - UIDocumentMenuDelegate

- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker {
    documentPicker.delegate = self;
    self.parent.modalPresentationStyle = UIModalPresentationPopover;
    [self.parent presentViewController:documentPicker animated:YES completion:nil];
}

# pragma mark - UIDocumentPickerDelegate

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    [NavigationUtility progressBeginInView:self.parent.view];
    @try {
        PFFile *file = [PFFile fileWithName:@"parse file" contentsAtPath:[url path]];
        NSDictionary *dictionary = @{
                                     @"title": [url lastPathComponent],
                                     @"file": file,
                                     @"course": self.course
                                     };
        [MaterialManager createMaterialWithDictionary:dictionary withCompletion:^(Material *material, NSError *error) {
            NSMutableArray *materials = [NSMutableArray arrayWithArray:self.course.materials];
            [materials addObject:material];
            self.course.materials = materials;
            _completionHandler(material, error);
        }];
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get the file. This usually happens when the file is too big or the internet connection was lost." delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
        _completionHandler(nil, [NSError errorWithDomain:@"com.box.Pencils" code:1 userInfo:nil]);
    }
    @finally {
        [NavigationUtility progressStop];
    }
}

-(void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    _completionHandler(nil, nil);
}

@end
