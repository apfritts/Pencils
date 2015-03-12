//
//  BoxClient.h
//  Pencils
//
//  Created by Thuy Nguyen on 3/10/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoxClient : NSObject
+ (NSString *)convertFile:(NSString *)url;
+ (NSURL *) getPreviewFile:(NSString *)id;
@end
