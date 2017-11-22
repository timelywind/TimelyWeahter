//
//  TLCityPickerController.m
//  TLCityPickerDemo
//
//  Created by TT on 15/11/5.
//  Copyright © 2015年 TT. All rights reserved.
//

#import "TLCityPickerController.h"
#import "TLCityPickerSearchResultController.h"
#import "TLCityHeaderView.h"
#import "TLCityGroupCell.h"
#import "TYGuideTool.h"
#import "AppDelegate.h"
#import "PreConfig.h"
#import "CustomNavigationBar.h"

@interface TLCityPickerController () <TLCityGroupCellDelegate, TLSearchResultControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) TLCityPickerSearchResultController *searchResultVC;

@property (nonatomic, strong) NSMutableArray *cityData;
@property (nonatomic, strong) NSMutableArray *localCityData;
@property (nonatomic, strong) NSMutableArray *hotCityData;
@property (nonatomic, strong) NSMutableArray *commonCityData;
@property (nonatomic, strong) NSMutableArray *arraySection;

@end

@implementation TLCityPickerController
@synthesize data = _data;
@synthesize commonCitys = _commonCitys;

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!_hotCitys.count) {
        self.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    }
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationItem setTitle:@"城市选择"];
    
    if (_type != TLCityPickerTypeFirst) {
        UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonDown:)];
        
        [self.navigationItem setLeftBarButtonItem:cancelBarButton];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"guide_03_ip5.jpg"];
    imageView.userInteractionEnabled = YES;
    self.tableView.backgroundView = imageView;
    
//    self.tableView.frame = self.view.bounds;
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerClass:[TLCityGroupCell class] forCellReuseIdentifier:@"TLCityGroupCell"];
    [self.tableView registerClass:[TLCityHeaderView class] forHeaderFooterViewReuseIdentifier:@"TLCityHeaderView"];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor whiteColor];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 2) {
        return 1;
    }
    TLCityGroup *group = [self.data objectAtIndex:section - 2];
    return group.arrayCitys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 2) {
        TLCityGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLCityGroupCell"];
//        if (indexPath.section == 0) {
//            [cell setTitle:@"定位城市"];
//            [cell setCityArray:self.localCityData];
//        }
//        else
            if (indexPath.section == 0) {
            [cell setTitle:@"最近访问城市"];
            [cell setCityArray:self.commonCityData];
        }
        else {
            [cell setTitle:@"热门城市"];
            [cell setCityArray:self.hotCityData];
        }
        [cell setDelegate:self];

        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    TLCityGroup *group = [self.data objectAtIndex:indexPath.section - 2];
    TLCity *city =  [group.arrayCitys objectAtIndex:indexPath.row];
    [cell.textLabel setText:city.cityName];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 2) {
        return nil;
    }
    TLCityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLCityHeaderView"];
    NSString *title = [_arraySection objectAtIndex:section + 1];
    [headerView setTitle:title];
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return [TLCityGroupCell getCellHeightOfCityArray:self.localCityData];
//    }
//    else
        if (indexPath.section == 0) {
        return [TLCityGroupCell getCellHeightOfCityArray:self.commonCityData];
    }
    else if (indexPath.section == 1){
        return [TLCityGroupCell getCellHeightOfCityArray:self.hotCityData];
    }
    return 43.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 2) {
        return 0.0f;
    }
    return 23.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < 2) {
        return;
    }
    TLCityGroup *group = [self.data objectAtIndex:indexPath.section - 2];
    TLCity *city = [group.arrayCitys objectAtIndex:indexPath.row];
    [self didSelctedCity:city];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.arraySection;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(index == 0) {
        [self.tableView scrollRectToVisible:self.searchController.searchBar.frame animated:NO];
        return -1;
    }
    return index - 2;
}

#pragma mark TLCityGroupCellDelegate
- (void) cityGroupCellDidSelectCity:(TLCity *)city
{
    [self didSelctedCity:city];
}

#pragma mark TLSearchResultControllerDelegate
- (void) searchResultControllerDidSelectCity:(TLCity *)city
{
    [self.searchController dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self didSelctedCity:city];
}

#pragma mark - Event Response
- (void) cancelButtonDown:(UIBarButtonItem *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerControllerDidCancel:)]) {
        [_delegate cityPickerControllerDidCancel:self];
    }
}

#pragma mark - Private Methods
- (void) didSelctedCity:(TLCity *)city
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerController:didSelectCity:)]) {
        [_delegate cityPickerController:self didSelectCity:city];
    }
    
    if (self.commonCitys.count >= MAX_COMMON_CITY_NUMBER) {
        [self.commonCitys removeLastObject];
    }
    for (NSString *str in self.commonCitys) {
        if ([city.cityID isEqualToString:str]) {
            [self.commonCitys removeObject:str];
            break;
        }
    }
    [self.commonCitys insertObject:city.cityID atIndex:0];
    [[NSUserDefaults standardUserDefaults] setValue:self.commonCitys forKey:COMMON_CITY_DATA_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if (city.cityName.length && _type == TLCityPickerTypeFirst) {
        NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
        [df setObject:city.cityName forKey:@"TYCityName"];
        [df synchronize];
        
        [[UIApplication sharedApplication] delegate].window.rootViewController = [TYGuideTool configRootViewController];
    }
}

#pragma mark - Setter
- (void) setCommonCitys:(NSMutableArray *)commonCitys
{
    _commonCitys = commonCitys;
    if (commonCitys != nil && commonCitys.count > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:commonCitys forKey:COMMON_CITY_DATA_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - Getter 
- (UISearchController *) searchController
{
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultVC];
        [_searchController.searchBar setPlaceholder:@"搜索城市（中文/拼音)"];

        [_searchController.searchBar setBarTintColor:WColorRGB(89, 125, 201)];
        _searchController.searchBar.tintColor = [UIColor whiteColor];
        [_searchController.searchBar sizeToFit];
        [_searchController setSearchResultsUpdater:self.searchResultVC];
//        [_searchController.searchBar.layer setBorderWidth:0.5f];
//        [_searchController.searchBar.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];
        
        _searchController.searchBar.backgroundImage = [self imageWithColor:WColorRGB(89, 125, 201)];
    }
    return _searchController;
}

// 用颜色制作图片
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGFloat imageW = 100;
    CGFloat imageH = 100;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (TLCityPickerSearchResultController *) searchResultVC
{
    if (_searchResultVC == nil) {
        _searchResultVC = [[TLCityPickerSearchResultController alloc] init];
        _searchResultVC.cityData = self.cityData;
        _searchResultVC.searchResultDelegate = self;
    }
    return _searchResultVC;
}

- (NSMutableArray *)data
{
    if (_data == nil) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"]];
        _data = [[NSMutableArray alloc] init];
        for (NSDictionary *groupDic in array) {
            TLCityGroup *group = [[TLCityGroup alloc] init];
            group.groupName = [groupDic objectForKey:@"initial"];
            for (NSDictionary *dic in [groupDic objectForKey:@"citys"]) {
                TLCity *city = [[TLCity alloc] init];
                city.cityID = [dic objectForKey:@"city_key"];
                city.cityName = [dic objectForKey:@"city_name"];
                city.shortName = [dic objectForKey:@"short_name"];
                city.pinyin = [dic objectForKey:@"pinyin"];
                city.initials = [dic objectForKey:@"initials"];
                [group.arrayCitys addObject:city];
                [self.cityData addObject:city];
            }
            [self.arraySection addObject:group.groupName];
            [_data addObject:group];
        }
    }
    return _data;
}

- (NSMutableArray *) cityData
{
    if (_cityData == nil) {
        _cityData = [[NSMutableArray alloc] init];
    }
    return _cityData;
}

- (NSMutableArray *) localCityData
{
    if (_localCityData == nil) {
        _localCityData = [[NSMutableArray alloc] init];
        
        
        
        if (self.locationCityID != nil) {
            TLCity *city = nil;
            for (TLCity *item in self.cityData) {
                
                if ([item.cityName isEqualToString:self.locationCityID]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                NSLog(@"Not Found City: %@", self.locationCityID);
            }
            else {
                [_localCityData addObject:city];
            }
        }
    }
    return _localCityData;
}

- (NSMutableArray *) hotCityData
{
    if (_hotCityData == nil) {
        _hotCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.hotCitys) {
            TLCity *city = nil;
            for (TLCity *item in self.cityData) {
                if ([item.cityID isEqualToString:str]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                NSLog(@"Not Found City: %@", str);
            }
            else {
                [_hotCityData addObject:city];
            }
        }
    }
    return _hotCityData;
}

- (NSMutableArray *) commonCityData
{
    if (_commonCityData == nil) {
        _commonCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.commonCitys) {
            TLCity *city = nil;
            for (TLCity *item in self.cityData) {
                if ([item.cityID isEqualToString:str]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                NSLog(@"Not Found City: %@", str);
            }
            else {
                [_commonCityData addObject:city];
            }
        }
    }
    return _commonCityData;
}

- (NSMutableArray *) arraySection
{
    if (_arraySection == nil) {
        _arraySection = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, @"最近", @"最热", nil];
    }
    return _arraySection;
}

- (NSMutableArray *) commonCitys
{
    if (_commonCitys == nil) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:COMMON_CITY_DATA_KEY];
        _commonCitys = (array == nil ? [[NSMutableArray alloc] init] : [[NSMutableArray alloc] initWithArray:array copyItems:YES]);
    }
    return _commonCitys;
}

@end
