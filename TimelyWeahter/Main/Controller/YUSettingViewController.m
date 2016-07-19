//
//  YUSettingViewController.m
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/6.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "YUSettingViewController.h"
#import <SDImageCache.h>
#import "NSString+File.h"
#import <SVProgressHUD.h>
#import "YUAboutViewController.h"

@interface YUSettingViewController ()

@end

@implementation YUSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"系统设置";
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YUScreenW, YUScreenH)];
    
    imageView.image = [UIImage imageNamed:@"newa"];
    imageView.userInteractionEnabled = YES;
    
    self.tableView.backgroundView = imageView;

    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UIImage *image = [UIImage imageNamed:@"navigationbarBackgroundWhite"];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsCompact];$(PRODUCT_BUNDLE_IDENTIFIER)
    
   // [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"版本信息 1.0";
            break;
        case 1:
            cell.textLabel.text = @"关于";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
        {
            NSString *imageCachePath = [SDImageCache sharedImageCache].diskCachePath;
            long long fileSize = [imageCachePath fileSize];
            cell.textLabel.text = [NSString stringWithFormat:@"清理缓存(%.1fK)", fileSize / 1024.0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        default:
            break;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        YUAboutViewController *aboutVc = [[YUAboutViewController alloc]init];
        
        [self.navigationController pushViewController:aboutVc animated:YES];
    } else if (indexPath.row == 2) {

        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"清理缓存 ？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            return;
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *imageCachePath = [SDImageCache sharedImageCache].diskCachePath;
            
            // 清除缓存
            NSFileManager *mgr = [NSFileManager defaultManager];
            [mgr removeItemAtPath:imageCachePath error:nil];
            [SVProgressHUD showSuccessWithStatus:@"清理成功"];
            // 刷新表格
            [self.tableView reloadData];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}



@end
