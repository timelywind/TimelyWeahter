//
//  YUWeatherTrendView.m
//  TimelyWeahter
//
//  Created by timely on 15/3/1.
//  Copyright © 2016年 timely. All rights reserved.
//

#import "YUWeatherTrendView.h"
#import "YUWeatherDataModel.h"
#import "UIColor+Extension.h"
#import "UIView+Extension.h"

@interface YUWeatherTrendView ()

@property(nonatomic, assign) NSInteger maxHigh;
@property(nonatomic, assign) NSInteger minLow;
@property(nonatomic, copy) NSArray *trendModelArr;
@property(nonatomic, strong) NSMutableArray *highTemps;
@property(nonatomic, strong) NSMutableArray *lowTemps;
@property(nonatomic, strong) UIBezierPath *topLinePath;
@property(nonatomic, strong) UIBezierPath *bottomLinePath;
@property(nonatomic, assign) BOOL drawMask;

@property (nonatomic, strong) CAShapeLayer *topLineLayer;

@property (nonatomic, strong) CAShapeLayer *bottomLineLayer;

@end

@implementation YUWeatherTrendView

- (instancetype)initWithFrame:(CGRect)frame weatherModels:(NSArray *)weatherModels
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setWeatherModels:(NSArray *)weatherModels
{
    _weatherModels = weatherModels;
    self.trendModelArr = weatherModels;
    self.maxHigh = CGFLOAT_MIN;
    self.minLow = CGFLOAT_MAX;
    [self setupData];
}

- (void)setupData{
    if(self.trendModelArr.count > 0){
        self.minLow = 100;
        for (int i = 0; i < self.trendModelArr.count; i++) {
            YUWeatherDataModel *model = (YUWeatherDataModel*)self.trendModelArr[i];
            
            if([model.day_air_temperature integerValue] >= self.maxHigh){
                self.maxHigh = [model.day_air_temperature integerValue];
            }
            
            if(self.minLow > [model.night_air_temperature integerValue]){
                self.minLow = [model.night_air_temperature integerValue];
                
            }
            [self.highTemps addObject:model.day_air_temperature];
            [self.lowTemps addObject:model.night_air_temperature];
        }
    }
    self.maxHigh += 1;
    self.minLow -= 1;

}


- (void)drawRect:(CGRect)rect{
    
    [self.topLinePath removeAllPoints];
    [self.bottomLinePath removeAllPoints];
    
    UIColor *topColor = [UIColor yellowColor];
    UIColor *bottomColor = [UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000];
    
    CGFloat height = CGRectGetHeight(rect);
    CGFloat width = CGRectGetWidth(rect) - 40;
    [[UIColor colorWithWhite:0.902 alpha:1.000] set];
    UIBezierPath *linetop = [UIBezierPath bezierPathWithRect:CGRectMake(20, 0, width, 0.6)];
    [linetop fill];
    UIBezierPath *lineTwo = [UIBezierPath bezierPathWithRect:CGRectMake(20, height/3, width, 0.6)];
    [lineTwo fill];
    UIBezierPath *lineThree = [UIBezierPath bezierPathWithRect:CGRectMake(20, height/3*2, width, 0.6)];
    [lineThree fill];
    UIBezierPath *lineBottom = [UIBezierPath bezierPathWithRect:CGRectMake(20, height-1, width, 0.6)];
    [lineBottom fill];
    
    CGFloat maxBetween = self.maxHigh - self.minLow;
    
    CGFloat pointRad = 2;
    for (int i = 0 ;i < 7 && i < self.trendModelArr.count; i++) {
        
        YUWeatherDataModel *model = (YUWeatherDataModel * )self.trendModelArr[i];
        CGPoint topPoint = CGPointMake(model.centerX,self.height+4- ([model.day_air_temperature integerValue]-self.minLow)/maxBetween*self.height);
        if(i==0){
            [self.topLinePath moveToPoint:topPoint];
        }else{
            [self.topLinePath addLineToPoint:topPoint];
            [self.topLinePath moveToPoint:topPoint];
        }
        
        UIBezierPath *tempPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(topPoint.x - pointRad, topPoint.y - pointRad, pointRad * 2, pointRad * 2) cornerRadius:pointRad];
        [topColor set];
        [tempPath fill];
        
        [[NSString stringWithFormat:@"%@℃",model.day_air_temperature] drawAtPoint:topPoint withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:topColor}];
    }
    
    for (int i = 0 ; i < 7 && i < self.trendModelArr.count; i++) {
        YUWeatherDataModel *model = (YUWeatherDataModel *)self.trendModelArr[i];
        CGPoint bottomPoint = CGPointMake(model.centerX, self.height-4- ([model.night_air_temperature integerValue]-self.minLow)/maxBetween*self.height);
        
        if(i==0){
            [self.bottomLinePath moveToPoint:bottomPoint];
        }else{
            [self.bottomLinePath addLineToPoint:bottomPoint];
            [self.bottomLinePath moveToPoint:bottomPoint];
        }

        if (bottomPoint.y > 130) {
            bottomPoint.y -= 10;
        }
        
        UIBezierPath *tempPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(bottomPoint.x - pointRad, bottomPoint.y - pointRad, pointRad * 2, pointRad * 2) cornerRadius:pointRad];
        [bottomColor set];
        [tempPath fill];
        
        [[NSString stringWithFormat:@"%@℃",model.night_air_temperature] drawAtPoint:bottomPoint withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:bottomColor}];
    }
 
    [[NSString stringWithFormat:@"%zd℃",self.maxHigh] drawAtPoint:CGPointMake(5, 0) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:topColor}];
    
    [[NSString stringWithFormat:@"%zd℃",self.minLow] drawAtPoint:CGPointMake(5, self.height-14) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:bottomColor}];
}

- (void)startTempLineAnimation
{
    NSArray *tempLayerArr = [NSArray arrayWithObjects:self.topLineLayer, self.bottomLineLayer, nil];
    
    for (int i = 0; i < tempLayerArr.count; i++) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue   = @1.0f;

        CAShapeLayer *shapeLayer = tempLayerArr[i];
        if (i == 0) {
            shapeLayer.path = self.topLinePath.CGPath;
        } else {
            shapeLayer.path = self.bottomLinePath.CGPath;
        }
        [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
    
    [self startMaskAnimation];
}

- (void)startMaskAnimation{
    self.drawMask = YES;
    [self setNeedsDisplay];
}

#pragma mark - 懒加载

- (CAShapeLayer *)topLineLayer
{
    if (_topLineLayer == nil) {
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
        shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
        shapeLayer.lineWidth = 1.0;
        [self.layer addSublayer:shapeLayer];
        _topLineLayer = shapeLayer;
    }
    return _topLineLayer;
}

- (CAShapeLayer *)bottomLineLayer
{
    if (_bottomLineLayer == nil) {
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
        shapeLayer.strokeColor = [UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000].CGColor;
        shapeLayer.lineWidth = 1.0;
        [self.layer addSublayer:shapeLayer];
        _bottomLineLayer = shapeLayer;
    }
    return _bottomLineLayer;
}

- (NSMutableArray *)highTemps{
    if(!_highTemps){
        _highTemps = [NSMutableArray array];
    }
    return _highTemps;
}

-(NSMutableArray *)lowTemps{
    if(!_lowTemps){
        _lowTemps = [NSMutableArray array];
    }
    return _lowTemps;
}

- (UIBezierPath *)topLinePath{
    if(!_topLinePath){
        _topLinePath = [UIBezierPath bezierPath];
    }
    return _topLinePath;
}

- (UIBezierPath *)bottomLinePath{
    if(!_bottomLinePath){
        _bottomLinePath = [UIBezierPath bezierPath];
    }
    return _bottomLinePath;
}

@end
