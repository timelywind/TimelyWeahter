//
//  YUMainViewController.m
//  TimelyWeahter
//
//  Created by timely on 15/3/1.
//  Copyright © 2016年 timely. All rights reserved.
//

#import "YUMainViewController.h"
#import "YUNetHelp.h"
#import "NSString+MD5.h"
#import "YUTopWeatherView.h"
#import "YUWeatherDataModel.h"
#import "YULivingIndexModel.h"
#import "MJExtension.h"
#import "YUWeatherInformationCell.h"
#import "YULivingIndexCell.h"
#import "YUNowWeather.h"
#import "YUSettingViewController.h"
#import "TLCityPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import "MJRefresh.h"
#import "YUNavigationController.h"
#import "TRYRefreshHeader.h"
#import "PreConfig.h"
#import "TRYCustomHud.h"
#import "UIImage+Color.h"
#import "UIViewController+AppearController.h"

static NSString *TYCityName = @"TYCityName";

@interface YUMainViewController () <UITableViewDelegate, UITableViewDataSource, TLCityPickerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *weatherModels;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YUTopWeatherView *topView;

@property (nonatomic, strong)  YULivingIndexModel *lvingIndexModel;
/** 位置管理者 */
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSString *area;

@property (nonatomic, strong) NSString *locationCity;

@property (nonatomic, strong) UIButton *btn;
@end

@implementation YUMainViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self setupTableView];
    
    [self loadWeather];  //com.timelyweather
    
    [self setupRefresh];
    
//    [[YUNetHelp shareManager]  isReachToWeb];
    
    [self.view insertSubview:self.customNavigationBar aboveSubview:self.tableView];
    self.customNavigationBar.backgroundColor = WColorRGBA(1, 1, 1, 0.03);
}

- (void)controllerWillAppear{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)controllerWillDisappear{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadWeather
{
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    NSString * city = [df objectForKey:TYCityName];
    
    [self loadWeatherWithArea: city ? city: @"北京市"];
    
}
- (void)setupRefresh
{
    self.tableView.mj_header = [TRYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadWeatherWithRefresh)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)loadWeatherWithRefresh
{
    [self loadWeatherWithArea:self.area];
}

- (CLLocationManager *)locationManager
{
    //检测定位功能是否开启
        if(!_locationManager){
            
            self.locationManager = [[CLLocationManager alloc] init];
            
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                [self.locationManager requestWhenInUseAuthorization];
            }
            self.view.backgroundColor = [UIColor yellowColor];
            //设置代理
            [self.locationManager setDelegate:self];
        }
    return _locationManager;
}

- (void)setupNav
{
    [self.leftButton setImage:[[UIImage imageNamed:@"edit_left"] imageWithColor: WColorRGBA(220, 220, 220, 1.0)] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateNormal];
//    [self.leftButton setTitle:@"切换城市" forState:UIControlStateNormal];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 100, 30);
//    self.btn = btn;
//    [btn setTitle:@"" forState:UIControlStateNormal];
//
//    [btn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
//
//    self.navigationItem.titleView = btn;
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"切换城市" style:UIBarButtonItemStylePlain target:self action:@selector(changeCity)];
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"mine-setting-icon-click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settingItemClick)];
}

- (void)location
{
    //开始定位
    [self.locationManager startUpdatingLocation];
    
    [self.btn setTitle:@"正在定位" forState:UIControlStateNormal];
}


- (void)loadWeatherWithArea:(NSString *)area
{
    if (area == nil) {
        
        [self.tableView.mj_header endRefreshing];
        
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请点击左上角按钮，选择您的城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
        return;
    }

    self.area = area;
    
    __weak typeof (self) weakSelf = self;
    [YUNetHelp requestWeatherForCity:area complete:^(BOOL success, id result) {
        if (success) {

            NSError *error = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
            
            
            NSDictionary *tmpDict = dict[@"showapi_res_body"];
            
            NSMutableArray *tmpArray = [NSMutableArray array];

            for (NSString *key in tmpDict.allKeys) {
                
                if (key.length == 2) {
                    
                    YUWeatherDataModel *weatherModel = [YUWeatherDataModel mj_objectWithKeyValues:tmpDict[key]];
                    [tmpArray addObject:weatherModel];
                }
            }
            
            if (tmpArray.count > 6) {
                // 天气模型
                self.weatherModels = @[tmpArray[1],tmpArray[4],tmpArray[6],tmpArray[2],tmpArray[5],tmpArray[0],tmpArray[3]];
                // 生活指数模型
                YULivingIndexModel *livingIndexModel = [YULivingIndexModel mj_objectWithKeyValues:tmpDict[@"f1"][@"index"]];
                // 当前天气模型
                YUNowWeather *nowWeather =[YUNowWeather mj_objectWithKeyValues:tmpDict[@"now"]];
                nowWeather.city = tmpDict[@"cityInfo"][@"c3"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.topView.weatherModels = weakSelf.weatherModels;
                    weakSelf.topView.nowWeather = nowWeather;
                    weakSelf.lvingIndexModel = livingIndexModel;
                });
                
                [UIView animateWithDuration:0.2 animations:^{
                    _tableView.alpha = 1;
                }];
                
                NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
                [df setObject:area forKey:@"TYCityName"];
                [df synchronize];
                
                self.titleStr = area;
            }
            
            [weakSelf.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];

        } else {
            
            [weakSelf.tableView reloadData];
            self.tableView.alpha = 1.0;

            [self.tableView.mj_header endRefreshing];
            [TRYCustomHud showHudWithTipText:@"网络异常，请检查您的网络" delay:0.8];
        }
        
    }];
    
}

- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat topHeight = kStatusBarHeight + kNavBarHeight;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"new_feature_1.jpg"];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, topHeight, YUScreenW, self.view.bounds.size.height - topHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;

    tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    YUTopWeatherView *topView = [YUTopWeatherView topWeatherView];
    topView.frame = CGRectMake(0, 0, YUScreenW, 400);
    self.tableView.tableHeaderView = topView;
    self.topView = topView;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YUWeatherInformationCell class]) bundle:nil] forCellReuseIdentifier:@"YUWeatherInformationCell"];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YULivingIndexCell class]) bundle:nil] forCellReuseIdentifier:@"YULivingIndexCell"];

    
    if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }

    tableView.alpha = 0;
}

#pragma mark -tableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.weatherModels.count == 0) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.weatherModels.count == 0) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
    YUWeatherInformationCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"YUWeatherInformationCell"];

        cell.weatherModel = [self.weatherModels firstObject];
        return cell;
    } else {
        YULivingIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YULivingIndexCell"];
        cell.livingIndexModel = self.lvingIndexModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    } else {
        return 385;
    }
}

- (void)defaultLeftButtonClick
{
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    cityPickerVC.delegate = self;
    
    // 设置定位城市
    cityPickerVC.locationCityID = self.locationCity;
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    [self presentViewController:[[YUNavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:nil];
}

- (void)defaultRightButtonClick
{
    YUSettingViewController *settingVc = [[YUSettingViewController alloc]init];
    
    [self.navigationController pushViewController:settingVc animated:YES];
    
}

#pragma mark - TLCityPickerDelegate
- (void)cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
    }];
    self.area = city.cityName;
    [self.tableView.mj_header beginRefreshing];
}

- (void)cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - CLLocationManangerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            // 用户还未决定
        case kCLAuthorizationStatusNotDetermined:
        {
         //   NSLog(@"用户还未决定");
            break;
        }
            // 问受限
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
            // 定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled])
            {
                
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已拒绝定位,请选择您的城市加载天气" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];
                
            }else
            {
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有开启定位功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];

            }
            break;
        }
            // 获得前台定位授权
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            //设置定位精度
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //设置距离筛选
            [self.locationManager setDistanceFilter:100];
            
            //设置开始识别方向
            [self.locationManager startUpdatingHeading];
            
            break;
        }
        default:
            break;
    }
    
}

//定位成功以后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = locations.lastObject;
    [self reverseGeocoder:location];
    
}

#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error || placemarks.count == 0){

            [self.btn setTitle:@"开始定位" forState:UIControlStateNormal];
        }else{
            [self.btn setTitle:@"开始定位" forState:UIControlStateNormal];
            CLPlacemark *placemark = placemarks.firstObject;
            
            NSString *city = [[placemark addressDictionary] objectForKey:@"City"];
    
            if ([self.locationCity isEqualToString:city]) return ;
            self.locationCity = city;
            
            [self loadWeatherWithArea:self.locationCity];
            
            NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
            [df setObject:city forKey:@"city"];
            [df synchronize];
        }
    }];
}

@end
