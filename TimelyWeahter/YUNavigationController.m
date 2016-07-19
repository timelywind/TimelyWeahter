//
//  YUNavigationController.m
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "YUNavigationController.h"
#import "UIImage+Color.h"

@interface YUNavigationController ()

@end

@implementation YUNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = YES;
    
//    UIImage *image = [UIImage imageWithColor:WColorRGB(89, 125, 201)];
//    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
/**
 *  只会调用一次
 */
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    
    UIImage *image = [UIImage imageWithColor:WColorRGB(89, 125, 201)];
    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    [bar setTitleTextAttributes:attrs];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:@"返回" forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];

        button.size = CGSizeMake(70, 30);
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
      //  [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        // 修改导航栏左边的item
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
