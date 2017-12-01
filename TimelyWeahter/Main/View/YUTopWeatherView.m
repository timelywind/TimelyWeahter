//
//  YUTopWeatherView.m
//  TimelyWeahter
//
//  Created by timely on 15/3/1.
//  Copyright © 2016年 timely. All rights reserved.
//

#import "YUTopWeatherView.h"
#import "YUWeatherTrendView.h"
#import "UIButton+Extension.h"
#import "UIColor+Extension.h"
#import "NSDate+Extenion.h"
#import "YUWeatherDataModel.h"
#import "YUVerticalButton.h"
#import "YUNowWeather.h"
#import "NSDate+Formatter.h"
#import "PreConfig.h"
#import "UIView+Extension.h"

#define labelW 32
#define leftMargin (iPhone6? 30 :10)
#define weekDaysViewH 30
#define weekDaysViewY 150
#define dayViewH 20
#define btnH 60
#define weatherTrendViewH 140

@interface YUTopWeatherView ()
@property (nonatomic, strong) YUWeatherTrendView *weatherTrendView;

@property(nonatomic, strong)UIView *dayView;
@property(nonatomic, strong)UIView *weekDaysView;
@property(nonatomic, strong)NSMutableArray *weekDays;
@property(nonatomic, strong)NSMutableArray *weekLabels;
@property(nonatomic, strong)NSMutableArray *DayBtns;
@property(nonatomic, strong)NSMutableArray *nightBtns;
@property(nonatomic, strong)NSMutableArray *dateLabels;

@property(nonatomic, strong)CAShapeLayer *shaperLayer;

@property (weak, nonatomic) IBOutlet YUVerticalButton *weatherBtn;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *airLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *airIndex;

@end

@implementation YUTopWeatherView

+ (id)topWeatherView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupSubViews];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

// 创建子视图
- (void)setupSubViews
{
    // 星期
    [self addSubview:self.weekDaysView];
    //    NSLog(@"%ld",weekOfDay);
    CGFloat centerMargin = (YUScreenW - leftMargin * 2 - labelW * 7) / 6;
    for (int i = 1; i <= 7; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin+(labelW+centerMargin)*(i-1), 0, labelW, labelW)];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.textColor = [UIColor whiteColor];
        [self.weekDaysView addSubview:label];
        [self.weekLabels addObject:label];
    }
    
    // 日期
    [self addSubview:self.dayView];
    for (int i = 0; i < 7; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin+(labelW+centerMargin)*(i), 0, labelW, dayViewH)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.textColor = [UIColor whiteColor];
        [self.dayView addSubview:label];
        [self.dateLabels addObject:label];
    }
    
    // day天气图片
    for (int i = 0; i < 7; i++) {
        CGFloat topMargin = weekDaysViewY + weekDaysViewH + dayViewH;
        YUVerticalButton *btn = [YUVerticalButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftMargin+(labelW+centerMargin)*i, topMargin, labelW, btnH);
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:btn];
        
        btn.userInteractionEnabled = NO;
        [self.DayBtns addObject:btn];
    }
    
    // night天气图片
    for (int i = 0; i < 7; i++) {
        CGFloat topMargin = weekDaysViewY + weekDaysViewH + dayViewH + btnH + weatherTrendViewH + 15;
        YUVerticalButton *btn = [YUVerticalButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftMargin+(labelW+centerMargin)*i, topMargin, labelW, btnH);
        
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:btn];
        btn.userInteractionEnabled = NO;
        [self.nightBtns addObject:btn];
    }
    
    if (_weatherTrendView == nil) {
        _weatherTrendView = [[YUWeatherTrendView alloc]init];
        [self addSubview:_weatherTrendView];
    }
}


- (void)setNowWeather:(YUNowWeather *)nowWeather
{
    _nowWeather = nowWeather;
    self.cityLabel.text = nowWeather.city;
    [self.weatherBtn try_setImageWithURLString:nowWeather.weather_pic forState:UIControlStateNormal];
    [self.weatherBtn setTitle:nowWeather.weather forState:UIControlStateNormal];
    
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@ ℃",nowWeather.temperature];
    self.airLabel.text = [NSString stringWithFormat:@"空气 %@",nowWeather.aqi];
    self.updateTimeLabel.text = [NSString stringWithFormat:@"上次更新 %@", nowWeather.updateTime];
    
    NSString *str = [[NSDate date] getChineseCalendarWithDate:[NSDate date]];
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"MM月dd日"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@  %@",nowDate,[str substringFromIndex:3]];
    
    self.windLabel.text = [NSString stringWithFormat:@"%@  %@",nowWeather.wind_direction,nowWeather.wind_power];
    
    [self configAirAqi:nowWeather.aqi];
}

- (void)setWeatherModels:(NSArray *)weatherModels
{
    _weatherModels = weatherModels;
    
    [self setupViewWith:weatherModels];
    
    self.weatherTrendView.weatherModels = weatherModels;
    [self.weatherTrendView setNeedsDisplay];
    
    [self startTrendAnimation];
}



- (void)setupViewWith:(NSArray *)weatherModels{
  
    for (int i = 0; i < 7; i++) {
        
        // 星期
        NSInteger weekOfDay = [[NSDate date]weekday];
        
        UILabel *weekLabel = self.weekLabels[i];
        weekLabel.text = (NSString *)self.weekDays[(weekOfDay -1 + i)%7];
        
//        NSLog(@"%@",self.weekDays[(weekOfDay -1 + i)%7]);
        
        YUWeatherDataModel *model = weatherModels[i];
        
        // 日期
        UILabel *dateLabel = self.dateLabels[i];
        
        NSString *str = [model.day substringFromIndex:4];
        NSMutableString *strM =[NSMutableString stringWithString:str];
        [strM insertString:@"/" atIndex:2];
        dateLabel.text = strM;
        model.centerX = dateLabel.centerX;

        // day天气图片
        UIButton *dayButton = self.DayBtns[i];
        [dayButton setTitle:model.day_weather forState:UIControlStateNormal];
        [dayButton try_setImageWithURLString:model.day_weather_pic forState:UIControlStateNormal];
        dayButton.titleLabel.font = [UIFont systemFontOfSize:13];
        if (model.day_weather.length > 2) {
            dayButton.titleLabel.font = [UIFont systemFontOfSize:8];
        }
        
        UIButton *nightButton = self.nightBtns[i];
        [nightButton setTitle:model.night_weather forState:UIControlStateNormal];
        [nightButton try_setImageWithURLString:model.night_weather_pic forState:UIControlStateNormal];
        nightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        if (model.night_weather.length > 2) {
            nightButton.titleLabel.font = [UIFont systemFontOfSize:8];
        }
    }
    
    
}



- (void)setFrame:(CGRect)frame
{
    frame.size.height = 667 * 0.75;
    
    [super setFrame:frame];
}


- (void)startTrendAnimation{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.weatherTrendView startTempLineAnimation];
    });
}


- (void)configAirAqi:(NSString *)aqi
{
    NSString *tmpString = nil;
    UIColor *color = nil;
    NSInteger index = [aqi integerValue];
    
    if (index <= 50) {
        tmpString = @"优";
        color = [UIColor greenColor];
    } else if (index <= 100) {
        tmpString = @"良";
        color = [UIColor colorWithRed:0.372 green:1.000 blue:0.000 alpha:1.000];
    } else if (index <= 150) {
        tmpString = @"轻度污染";
        color = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
    } else if (index <= 200) {
        tmpString = @"中度污染";
        color = [UIColor colorWithRed:1.000 green:0.300 blue:0.000 alpha:1.000];
    } else if (index <= 250) {
        tmpString = @"重度污染";
        color = [UIColor colorWithRed:0.845 green:0.000 blue:0.000 alpha:1.000];
    } else {
        tmpString = @"严重污染";
        color = [UIColor redColor];
    }
    self.airIndex.text = tmpString;
    self.airIndex.backgroundColor = [color colorWithAlphaComponent:0.5];
}






#pragma mark - Getters and Setters


- (CAShapeLayer *)shaperLayer{
    if(!_shaperLayer){
        _shaperLayer = [[CAShapeLayer alloc]init];
        _shaperLayer.frame = self.bounds;
    }
    return _shaperLayer;
}




- (UIView *)dayView{
    if(!_dayView){
        _dayView = [[UIView alloc]initWithFrame:CGRectMake(0, weekDaysViewY + weekDaysViewH, self.width, dayViewH)];
     //   _weekView.alpha = 0;
        _dayView.backgroundColor = [UIColor clearColor];
    }
    return _dayView;
}

- (UIView *)weekDaysView{
    if(!_weekDaysView){
        _weekDaysView = [[UIView alloc]initWithFrame:CGRectMake(0, weekDaysViewY, self.width, weekDaysViewH)];
   //     _weekDaysView.alpha = 0;
        _weekDaysView.backgroundColor = [UIColor clearColor];
    }
    return _weekDaysView;
}

- (NSMutableArray *)weekDays{
    if(!_weekDays){
        _weekDays = [NSMutableArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    }
    return _weekDays;
}

- (NSMutableArray *)weekLabels
{
    if (_weekLabels == nil) {
        
        _weekLabels = [NSMutableArray array];
    }
    return _weekLabels;
}

- (NSMutableArray *)dateLabels
{
    if (_dateLabels == nil) {
        
        _dateLabels = [NSMutableArray array];
    }
    return _dateLabels;
}

- (NSMutableArray *)DayBtns
{
    if (_DayBtns == nil) {
        
        _DayBtns = [NSMutableArray array];
    }
    return _DayBtns;
}

- (NSMutableArray *)nightBtns
{
    if (_nightBtns == nil) {
        
        _nightBtns = [NSMutableArray array];
    }
    return _nightBtns;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat topweatherViewH = 260; // YUScreenH * 0.4;
    
    self.weatherTrendView.frame = CGRectMake(0, topweatherViewH, YUScreenW, weatherTrendViewH);
    
}


@end
