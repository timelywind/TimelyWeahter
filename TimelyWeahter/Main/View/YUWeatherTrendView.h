//
//  YUWeatherTrendView.h
//  TimelyWeahter
//
//  Created by timely on 15/3/1.
//  Copyright © 2016年 timely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YUWeatherTrendView : UIView
@property (nonatomic, strong) NSArray *weatherModels;
- (instancetype)initWithFrame:(CGRect)frame weatherModels:(NSArray *)weatherModels;

- (void)startTempLineAnimation;

@end
