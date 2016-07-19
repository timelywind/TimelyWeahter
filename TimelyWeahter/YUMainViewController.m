//
//  YUMainViewController.m
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "YUMainViewController.h"
#import "YUNetHelp.h"
#import "NSDate+Formatter.h"
#import "NSString+MD5.h"
#import "YUTopWeatherView.h"
#import "YUWeatherDataModel.h"
#import "YULivingIndexModel.h"
#import <MJExtension.h>
#import "YUWeatherInformationCell.h"
#import "YULivingIndexCell.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import "YUNowWeather.h"
#import "YUSettingViewController.h"
#import "TLCityPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import <MJRefresh.h>
#import "YUNavigationController.h"

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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];
    
    [self loadWeather];  //com.timelyweather
    
    [self setupRefresh];
    
    [[YUNetHelp shareManager]  isReachToWeb];
    
}


- (void)loadWeather
{
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    NSString * city = [df objectForKey:@"city"];
    
    [self loadWeatherWithArea: city ? city:@"北京"];
    
}
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadWeatherWithRefresh)];
    self.tableView.mj_header.tintColor = [UIColor whiteColor];
    // 自动改变透明度
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    self.btn = btn;
    [btn setTitle:@"开始定位" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = btn;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"切换城市" style:UIBarButtonItemStylePlain target:self action:@selector(changeCity)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"mine-setting-icon-click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settingItemClick)];
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
    
   // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载最新天气" maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"yyyyMMddHHmmss"];

    NSString *path = @"9-2";
    NSString *secret = @"5cc4274ccad348ba86b53e5971082a6b";
//    NSString *sign = [NSString stringWithFormat:@"area%@needIndex1needMoreDay1showapi_appid16424showapi_timestamp%@%@",area,nowDate,secret];
//    NSString *md5Sign = [sign md532BitLower];
    
    NSDictionary *params = @{
                             @"area":area,
                             @"needIndex":@1,
                             @"needMoreDay":@1,
                             @"showapi_appid":@"16424",
                             @"showapi_timestamp":nowDate,
                             @"showapi_sign":secret,
                             };
    __weak typeof (self) weakSelf = self;
    [YUNetHelp POSTWithExtraUrl:path andParam:params andComplete:^(BOOL success, id result) {
        if (success) {
            // 隐藏指示器
            [SVProgressHUD dismiss];
            NSError *error = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
            
            if (error) {
                
                [SVProgressHUD showErrorWithStatus:@"网络数据请求失败"];
            }
            
            NSDictionary *tmpDict = dict[@"showapi_res_body"];
            
            NSMutableArray *tmpArray = [NSMutableArray array];

            for (NSString *key in tmpDict.allKeys) {
                
                if (key.length == 2) {
                    
                    YUWeatherDataModel *weatherModel = [YUWeatherDataModel mj_objectWithKeyValues:tmpDict[key]];
                    [tmpArray addObject:weatherModel];
                }
            }
            
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
            
            [weakSelf.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
            [self.tableView.mj_header endRefreshing];
        }
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YUScreenW, YUScreenH)];
    imageView.image = [UIImage imageNamed:@"new_feature_1"];

    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YUScreenW, YUScreenH) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;

    tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    YUTopWeatherView *topView = [YUTopWeatherView topWeatherView];
    topView.frame = CGRectMake(0, 0, YUScreenW, 400);
    self.tableView.tableHeaderView = topView;
    self.topView = topView;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YUWeatherInformationCell class]) bundle:nil] forCellReuseIdentifier:@"YUWeatherInformationCell"];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YULivingIndexCell class]) bundle:nil] forCellReuseIdentifier:@"YULivingIndexCell"];

}

#pragma mark -tableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (void)changeCity
{
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    cityPickerVC.delegate = self;
    
    // 设置定位城市
    cityPickerVC.locationCityID = self.locationCity;
    // 热门城市，需手动设置
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[YUNavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:nil];
}

- (void)settingItemClick
{
    YUSettingViewController *settingVc = [[YUSettingViewController alloc]init];
    
    [self.navigationController pushViewController:settingVc animated:YES];
    
}

#pragma mark - TLCityPickerDelegate
- (void)cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    __weak typeof (self) weekSelf = self;
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        [weekSelf loadWeatherWithArea:city.cityName];
    }];
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
