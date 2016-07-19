//
//  PreConfig.h
//  jianzhi
//
//  Created by 王广威 on 16/2/19.
//  Copyright © 2016年 北京千锋-王广威. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PreConfig_h
#define PreConfig_h

#pragma mark -- 颜色

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

/**
 *  标题文字颜色
 */
#define WColorFontTitle WColorRGB(38, 38, 38)
/**
 *  内容文字颜色
 */
#define WColorFontContent WColorRGB(115, 115, 115)
/**
 *  细节文字颜色
 */
#define WColorFontDetail WColorRGB(166, 166, 166)
/**
 *  主要颜色(绿)
 */
#define WColorMain WColorRGB(38, 204, 92)
/**
 *  辅助颜色(橙)
 */
#define WColorAssist WColorRGB(255, 180, 0)
/**
 *  提醒颜色(红)
 */
#define WColorAlert WColorRGB(234, 86, 66)
/**
 *  背景颜色
 */
#define WColorBg WColorRGB(239, 239, 244)
/**
 *  导航条颜色
 */
#define WColorNavBg WColorRGB(255, 255, 255)
/**
 *  浅灰色 透明度
 */
#define WColorLightGray WColorRGB(242, 242, 242)
/**
 *  深灰色 透明度
 */
#define WColorDarkGray WColorRGB(166, 166, 166)


#pragma mark -- 其他数值

//-------------------获取设备大小-------------------------
// NavBar高度
#define WNavigationBarHeight (44.0)
// 状态栏高度
#define WStatusBarHeight (20.0)
// 顶部高度
#define WTopHeight (WNavigationBarHeight + WStatusBarHeight)
// 底部 TabBar 高度
#define WTabBarHeight 49
// 动态获取屏幕宽高
#define WScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define WScreenWidth ([UIScreen mainScreen].bounds.size.width)
// 默认按钮高度
#define WButtonHeight 48
// 弹出框距左右边距
#define WLeftPedding 25
// 普通视图左右边距
#define WPedding 16

// 弹出框动画时间
#define WAnimationTime 0.25f
// 提示框弹出时间
#define WAlertViewPopTime 0.15f
// 提示框显示时间
#define WAlertViewShowTime 2.5f
// 圆角
#define WCornerRadius 4.0f
//字体大小
#define subTitleFont [UIFont systemFontOfSize:12.0]

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 是否输出 Log
#define isShowLog 1
#if isShowLog
#define WLog(Format, ...) fprintf(stderr,"%s: %s->%d\n%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat:Format, ##__VA_ARGS__] UTF8String])
#else
#define WLog(Format, ...)
#endif

#pragma mark -- 链接和 key

/**标识*/
static NSString *const TOKEN = @"565e9507862572d85920de12a783e09f";
/**
 *  其他链接、Key
 */
static NSString *const WMAMapAppKey = @"48ff103970cade4ccc97e9d2cd2c06fe";
static NSString *const WTencentAppKey = @"1104081544";
static NSString *const WWeixinAppKey = @"wx59622ad001b068da";
static NSString *const WWeixinAppAppSecret = @"2d5f89d0a97f0a57b6ea9901d963b541";
static NSString *const WTestInAppKey = @"e1f2d2d7af9f9071ac4b02addf341fcd";
static NSString *const WUMengAppKey = @"5569841667e58e4a1d000386";
static NSString *const WAppStoreLink = @"itms-apps://itunes.apple.com/cn/app/jian-zhi-wei-shi/id984365130?l=zh&ls=1&mt=8";
//申请的环信key
static NSString *const WEaseMobAppKey = @"hctd#hctd520";

static NSString *const WEaseMobLoginChange = @"loginStateChange";

#if DEBUG
static NSString *const WApsCertName = @"aps_dev";
#else
static NSString *const WApsCertName = @"aps_pro";
#endif

static NSString *const WBaseUrl = @"http://wap2.yojianzhi.com/";
static NSString *const WLbtUrl = @"http://html2.yojianzhi.com/wap/images/";

// 接口域名前缀
#define BASEURL @"http://wap.yojianzhi.com/"
// app 接口常量
#define YOURL @"http://wap2.yojianzhi.com/app_api.php"
// 请求接口
#define WAPURL @"http://wap2.yojianzhi.com/index.php"
// 首页轮播图接口图片基本链接
#define lbtBaseUrl @"http://html2.yojianzhi.com/wap/images/"
// 首页轮播图跳转链接基本 URL
#define lbtEventBaseUrl @"http://wap2.yojianzhi.com"
// PC 端活动详情页
#define activityDetailUrl @"http://wap2.yojianzhi.com/index.php?a=activity_info&id=%@"
// 兼职卫士协议
#define LisenceUrl @"http://wap2.yojianzhi.com/index.php?a=protocol"

// 123.57.46.40
static NSString *const WPayPre = @"123.57.46.40:8080";
static NSString *const WPayIncomeRankings  = @"http://123.57.46.40:8080/pay_app/payTradeInfo/getTradePageList";
static NSString *const WPayRanking = @"http://123.57.46.40:8080/pay_app/payAccount/getAccountRankings";
static NSString *const WPayGetAccountInfo  = @"http://123.57.46.40:8080/pay_app/payAccount/findByUserId";
static NSString *const WPayBindingCode  = @"http://123.57.46.40:8080/pay_app/httpSendSMS/getSMSCode";
static NSString *const WPayBindingAccount  = @"http://123.57.46.40:8080/pay_app/payAccount/bindPayAccount";
static NSString *const WPayDrawCash  = @"http://123.57.46.40:8080/pay_app/payDrawInfo/savePayDrawInfo";

static NSString *const WPaymentSignKey  = @"jzws_yjz_pay_8520";


#endif /* PreConfig_h */
