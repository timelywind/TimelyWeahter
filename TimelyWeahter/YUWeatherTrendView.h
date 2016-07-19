//
//  YUWeatherTrendView.h
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YUWeatherTrendView : UIView
@property (nonatomic, strong) NSArray *weatherModels;
- (instancetype)initWithFrame:(CGRect)frame weatherModels:(NSArray *)weatherModels;

- (void)startTopLineAnimation;

- (void)startBottomAnimation;

@end
