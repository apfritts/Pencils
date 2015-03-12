//
//  BoxClient.m
//  Pencils
//
//  Created by Thuy Nguyen on 3/10/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BoxClient.h"
#import <BoxSDK/BoxSDK.h>

@implementation BoxClient

NSString *API_KEY = @"v9dbg1ui4camckxdd5pq3aqjpm23exzb";

- (NSString *)convertFile:(NSURL *)url {
/*
 curl https://view-api.box.com/1/documents \
 -H "Authorization: Token YOUR_API_KEY" \
 -H "Content-Type: application/json" \
 -d '{"url": "https://bitcoin.org/bitcoin.pdf"}' \
 -X POST
 
 curl https://upload.view-api.box.com/1/documents \
 -H "Authorization: Token YOUR_API_TOKEN" \
 -H "Content-type: multipart/form-data" \
 -F file=@A_FILE_TO_UPLOAD
 */
    NSString *post = [NSString stringWithFormat: @"\"url\":\"%@\"", [url path]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    //NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:@"https://view-api.box.com/1/documents "]];
    [request setHTTPMethod:@"POST"];
    //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *token = [NSString stringWithFormat:@"Token %@", API_KEY];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    [request setTimeoutInterval:20.0];
    [request setHTTPBody:postData];
    NSURLResponse * response = nil;
    NSError * error = nil;
    //[NSURLConnection connectionWithRequest:request delegate:self];
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        //[data writeToFile:[fileURL path] options:NSDataWritingAtomic error:nil];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        NSString *fileId = json[@"id"];
        NSLog(@"convert to fileId %@", fileId);
        return fileId;
    } else {
        NSLog(@"error getting preview %@", error);
    }

    return nil;
}

+ (NSURL *) getPreviewFile:(NSString *)id {
    /*
     curl https://view-api.box.com/1/documents/DOCUMENT_ID/content \
     -H "Authorization: Token YOUR_API_KEY"
     */
    
    // Send a synchronous request
    NSString *url = [NSString stringWithFormat:@"https://view-api.box.com/1/documents/%@/content", id];
    NSString *token = [NSString stringWithFormat:@"Token %@", API_KEY];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setValue:token forHTTPHeaderField:@"Authorization"];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *fileURL = [[tmpDirURL URLByAppendingPathComponent:@"id"] URLByAppendingPathExtension:@"pdf"];
    NSLog(@"fileURL: %@", [fileURL path]);
    if (error == nil)
    {
        [data writeToFile:[fileURL path] options:NSDataWritingAtomic error:nil];
    } else {
        NSLog(@"error getting preview %@", error);
    }
    return fileURL;
}

@end
