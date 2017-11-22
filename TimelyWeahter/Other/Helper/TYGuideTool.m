//
//  TYGuideTool.m
//  NativeEastSports
//
//  Created by administrator on 17/5/19.
//  Copyright © 2017年 timely. All rights reserved.
//

#import "TYGuideTool.h"
#import "YUMainViewController.h"
#import "YUNavigationController.h"
#import "TLCityPickerController.h"
#import "YUNewsViewController.h"

static NSString *TYNotFirstInstallKey = @"TYNotFirstInstallKey";

@implementation TYGuideTool

// root控制器
+ (UIViewController *)configRootViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIViewController *rootViewController = nil;
    
    id isNotFirstInstall = [[NSUserDefaults standardUserDefaults] objectForKey:TYNotFirstInstallKey];
    
    if (isNotFirstInstall) {
        
        // 不是首次安装
        YUMainViewController *mainVc = [[YUMainViewController alloc]init];
        rootViewController = [[YUNavigationController alloc]initWithRootViewController:mainVc];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TYNotFirstInstallKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        rootViewController = [[YUNewsViewController alloc]init];
    }

    return rootViewController;
}

@end
