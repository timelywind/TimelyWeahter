//
//  YUTopWeatherView.h
//  TimelyWeahter
//
//  Created by timely on 15/3/1.
//  Copyright © 2016年 timely. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YUNowWeather;

@interface YUTopWeatherView : UIView

@property (nonatomic, strong) YUNowWeather *nowWeather;

@property (nonatomic, strong) NSArray *weatherModels;

+ (id)topWeatherView;

@end
