//
//  YUTopWeatherView.h
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YUNowWeather;

@interface YUTopWeatherView : UIView

@property (nonatomic, strong) YUNowWeather *nowWeather;

@property (nonatomic, strong) NSArray *weatherModels;

+ (id)topWeatherView;

@end
