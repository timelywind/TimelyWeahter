//
//  PreConfig.h
//  jianzhi
//
//  Created by timely on 15/2/19.
//  Copyright © 2016年 timelytimely-timely. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PreConfig_h
#define PreConfig_h

#define  iPhone5s   (YUScreenW == 320.f && YUScreenH == 568.f ? YES : NO)
#define  iPhone6    ((YUScreenW >= 375.f && YUScreenH >= 667.f ? YES : NO) || (YUScreenW >= 414.f && YUScreenH >= 736.f ? YES : NO))

// 与6s屏幕比例
#define TRYScreenWScale (YUScreenW/375.0)
#define TRYScreenHScale (YUScreenH/667.0)

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0

#pragma mark -- 颜色

#define TRYGlobalColor  WColorRGB(97, 125, 195)

// 随机数
#define WArcNum(x) arc4random_uniform(x)
// 颜色
#define WColorRGB(r, g, b) WColorRGBA(r, g, b, 1.000f)
#define WColorRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
// 随机颜色
#define WArcColor WColorRGB(WArcNum(128) + 128, WArcNum(128) + 128, WArcNum(128) + 128)

#define WColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define YUScreenW [UIScreen mainScreen].bounds.size.width
#define YUScreenH [UIScreen mainScreen].bounds.size.height
// 动态获取屏幕宽高
#define WScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define WScreenWidth ([UIScreen mainScreen].bounds.size.width)


#endif /* PreConfig_h */
