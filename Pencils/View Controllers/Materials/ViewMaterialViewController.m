/**
 * Purpose:
 *
 * Copyright 2015 Pencils Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ViewMaterialViewController.h"

@interface ViewMaterialViewController ()

@property (strong, nonatomic) Material *material;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewMaterialViewController

-(instancetype)initWithMaterial:(Material *)material {
    self = [super init];
    if (self) {
        self.material = material;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"View Material";
    NSURL *url = [NSURL URLWithString:@"https://app.box.com/s/82235i48qpfkwwsidacaram02xh41mz6"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

@end
