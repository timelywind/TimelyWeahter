//
//  YUNavigationController.m
//  TimelyWeahter
//
//  Created by timely on 15/3/1.
//  Copyright © 2016年 timely. All rights reserved.
//

#import "YUNavigationController.h"
#import "UIImage+Color.h"
#import "PreConfig.h"
#import "UIView+Extension.h"

@interface YUNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *willShowViewController;

@end

@implementation YUNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBar.translucent = YES;

    self.delegate = self;
    
    UIImageView *lineImageView = [self findHairlineImageViewUnder:self.navigationBar];
    lineImageView.hidden = YES;
    
}

//隐藏导航栏下部横线的相关方法
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    /** 原controller 将消失回调 */
    if ([self.willShowViewController respondsToSelector:@selector(controllerWillDisappear)]) {
        [self.willShowViewController performSelector:@selector(controllerWillDisappear) withObject:nil];
    }
    
    /** 新controller 将出现回调 */
    if ([viewController respondsToSelector:@selector(controllerWillAppear)]) {
        [viewController performSelector:@selector(controllerWillAppear) withObject:nil];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if (self.errorView) {
//        self.errorView.hidden = !(viewController == self.viewControllers[0]);
//        if (!self.errorView.hidden) {
//            [self.view bringSubviewToFront:self.errorView];
//        }
//    }
    
    /** 原controller 消失回调 */
    if ([self.willShowViewController respondsToSelector:@selector(controllerDidDisappear)]) {
        [self.willShowViewController performSelector:@selector(controllerDidDisappear) withObject:nil];
    }
    
    /** 新controller 出现回调 */
    if ([viewController respondsToSelector:@selector(controllerDidAppear)]) {
        [viewController performSelector:@selector(controllerDidAppear) withObject:nil];
    }
    
    self.willShowViewController = viewController;
}

@end
