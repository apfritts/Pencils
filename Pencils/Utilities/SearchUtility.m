//
//  SearchUtility.m
//  Pencils
//
//  Created by AP Fritts on 3/21/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "SearchUtility.h"

@interface SearchUtility() <UISearchBarDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) NSString *type;
@property (weak, nonatomic) NSString *keyPath;
@property (weak, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *filteredData;

@end

@implementation SearchUtility

-(instancetype)initWithTableView:(UITableView *)tableView type:(NSString *)type keyPath:(NSString *)keyPath data:(NSArray *)data {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.type = (NSString *)[type copy];
        self.keyPath = (NSString *)[keyPath copy];
        self.data = data;
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 38.0)];
        self.searchBar.searchBarStyle = UISearchBarStyleDefault;
        self.searchBar.showsCancelButton = YES;
        self.searchBar.delegate = self;
        self.searchBar.placeholder = [NSString stringWithFormat:@"Search %@", self.type];
    }
    return self;
}

-(NSArray *)filteredData {
    return _filteredData;
}

-(void)updateData:(NSArray *)data {
    self.data = data;
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
}

-(UIView *)searchBarView {
    return self.searchBar;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.filteredData = nil;
    } else {
        NSExpression *lhs = [NSExpression expressionForKeyPath:self.keyPath];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchText];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        self.filteredData = [self.data filteredArrayUsingPredicate:finalPredicate];
    }
    [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    self.filteredData = nil;
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBar:searchBar textDidChange:searchBar.text];
    [searchBar resignFirstResponder];
}

@end
