//
//  AppDelegate.m
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "YUMainViewController.h"
#import "YUNavigationController.h"
#import "YUNewsViewController.h"
#import "YUNetHelp.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    
    NSString *key = @"CFBundleShortVersionString";
    
    // 获得当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        
        self.window.rootViewController = [[YUNewsViewController alloc]init];

        // 储存
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:currentVersion forKey:key];
        [ud synchronize];
    } else {
    
    YUMainViewController *mainVc = [[YUMainViewController alloc]init];
    YUNavigationController *nav = [[YUNavigationController alloc]initWithRootViewController:mainVc];
    self.window.rootViewController= nav;
    }

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
