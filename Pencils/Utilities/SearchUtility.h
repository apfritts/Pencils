//
//  SearchUtility.h
//  Pencils
//
//  Created by AP Fritts on 3/21/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface SearchUtility : NSObject

-(instancetype)initWithTableView:(UITableView *)tableView type:(NSString *)type keyPath:(NSString *)keyPath data:(NSArray *)data;
-(NSArray *)filteredData;
-(void)updateData:(NSArray *)data;
-(UIView *)searchBarView;

@end
