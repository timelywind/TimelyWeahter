//
//  TLCityPickerSearchResultController.m
//  TLCityPickerDemo
//
//  Created by 李伯坤 on 15/11/5.
//  Copyright © 2015年 李伯坤. All rights reserved.
//

#import "TLCityPickerSearchResultController.h"
#import "TLCity.h"

@interface TLCityPickerSearchResultController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation TLCityPickerSearchResultController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"newda"];
    imageView.userInteractionEnabled = YES;
    
    self.tableView.backgroundView = imageView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    TLCity *city =  [self.data objectAtIndex:indexPath.row];
    [cell.textLabel setText:city.cityName];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TLCity *city = [self.data objectAtIndex:indexPath.row];
    if (_searchResultDelegate && [_searchResultDelegate respondsToSelector:@selector(searchResultControllerDidSelectCity:)]) {
        [_searchResultDelegate searchResultControllerDidSelectCity:city];
    }
}

#pragma mark - UISearchResultsUpdating
- (void) updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    [self.data removeAllObjects];
    for (TLCity *city in self.cityData){
        if ([city.cityName containsString:searchText] || [city.pinyin containsString:[searchText lowercaseString]] || [city.initials containsString:searchText]) {
            [self.data addObject:city];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Getter
- (NSMutableArray *) data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

@end
