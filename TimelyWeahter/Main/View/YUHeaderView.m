//
//  YUHeaderView.m
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "YUHeaderView.h"
#import "YUWeatherTrendView.h"
#import "YUTopWeatherView.h"

@interface YUHeaderView ()

@property (nonatomic, weak) YUTopWeatherView *topweatherView;

@property (nonatomic, weak) YUWeatherTrendView *weatherTrendView;

@end

@implementation YUHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        YUTopWeatherView *topweatherView = [YUTopWeatherView topWeatherView];
        [self addSubview:topweatherView];
        self.topweatherView = topweatherView;
        
        YUWeatherTrendView *weatherTrendView = [[YUWeatherTrendView alloc]init];
        self.weatherTrendView = weatherTrendView;
        
        [self addSubview:weatherTrendView];
        
        [self startTrendAnimation];
        
    }
    return self;
}

- (void)startTrendAnimation{
    
    CASpringAnimation *opacityAnimation = [CASpringAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.toValue = @(1);
    opacityAnimation.mass = 1;
    opacityAnimation.stiffness = 100;
    opacityAnimation.damping = 10;
    opacityAnimation.duration = 0.8;
    opacityAnimation.initialVelocity = 0;
    
    opacityAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    [self.weatherTrendView applyBasicAnimation:opacityAnimation toLayer:self.weatherTrendView.layer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.weatherTrendView startTopLineAnimation];
        [self.weatherTrendView startBottomAnimation];
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat topweatherViewH = YUScreenH * 0.3;
    self.topweatherView.frame = CGRectMake(0, 0, YUScreenW, topweatherViewH);
    
    self.weatherTrendView.frame = CGRectMake(0, CGRectGetMaxY(self.topweatherView.frame), YUScreenW, topweatherViewH);
    
}


@end
