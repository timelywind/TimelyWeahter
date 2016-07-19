//
//  YUWeatherTrendView.m
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "YUWeatherTrendView.h"
#import "YUWeatherDataModel.h"
#import "UIColor+Extension.h"

@interface YUWeatherTrendView ()

@property(nonatomic, assign)NSInteger maxHigh;
@property(nonatomic, assign)NSInteger minLow;
@property(nonatomic, strong)NSMutableArray *trendModel;
@property(nonatomic, strong)NSMutableArray *highTemps;
@property(nonatomic, strong)NSMutableArray *lowTemps;
@property(nonatomic, strong)UIBezierPath *topLinePath;
@property(nonatomic, strong)UIBezierPath *bottomLinePath;
@property(nonatomic, assign)BOOL drawMask;

@end

@implementation YUWeatherTrendView

#pragma mark - 懒加载

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
  //  NSMutableArray *tmpArray = [NSMutableArray array];
   // [tmpArray arrayByAddingObjectsFromArray:weatherModels];
    self.trendModel = weatherModels;
    self.maxHigh = CGFLOAT_MIN;
    self.minLow = CGFLOAT_MAX;
    [self setupData];
}

- (void)setupData{
    if(self.trendModel.count > 0){
        self.minLow = 100;
        for (int i = 0; i < self.trendModel.count; i++) {
            YUWeatherDataModel *model = (YUWeatherDataModel*)self.trendModel[i];
            
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
    
    for (int i = 0 ;i<7 && i<self.trendModel.count; i++) {
        
        YUWeatherDataModel *model = (YUWeatherDataModel * )self.trendModel[i];
        CGPoint topPoint = CGPointMake(model.centerX,self.height+4- ([model.day_air_temperature integerValue]-self.minLow)/maxBetween*self.height);
        if(i==0){
            [self.topLinePath moveToPoint:topPoint];
        }else{
            [self.topLinePath addLineToPoint:topPoint];
            [self.topLinePath moveToPoint:topPoint];
            
        }
        [[NSString stringWithFormat:@"%@℃",model.day_air_temperature] drawAtPoint:topPoint withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor yellowColor]}];
    }
    
    
    for (int i = 0 ;i<7 && i<self.trendModel.count; i++) {
        YUWeatherDataModel *model = (YUWeatherDataModel *)self.trendModel[i];
        CGPoint bottomPoint = CGPointMake(model.centerX, self.height-4- ([model.night_air_temperature integerValue]-self.minLow)/maxBetween*self.height);
        
        if(i==0){
            [self.bottomLinePath moveToPoint:bottomPoint];
        //    firstPoint = CGPointMake(model.centerX, self.height-3);
            
        }else{
            [self.bottomLinePath addLineToPoint:bottomPoint];
            [self.bottomLinePath moveToPoint:bottomPoint];
        }

        if (bottomPoint.y > 130) {
            
            bottomPoint.y -= 10;
        }
        [[NSString stringWithFormat:@"%@℃",model.night_air_temperature] drawAtPoint:bottomPoint withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000]}];
    }
 
    [[NSString stringWithFormat:@"%zd℃",self.maxHigh] drawAtPoint:CGPointMake(5, 0) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor yellowColor]}];
    
    [[NSString stringWithFormat:@"%zd℃",self.minLow] drawAtPoint:CGPointMake(5, self.height-14) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000]}];
}

- (void)startTopLineAnimation{
    
    CAShapeLayer *shapeLine = [[CAShapeLayer alloc]init];
    shapeLine.strokeColor = [UIColor yellowColor].CGColor;
    shapeLine.lineWidth = 2.0;
    [self.layer addSublayer:shapeLine];
    shapeLine.path = self.topLinePath.CGPath;
    [CATransaction begin];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue   = @1.0f;
    
    [shapeLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    shapeLine.strokeEnd = 1.0;
    
    [CATransaction commit];
}

- (void)startBottomAnimation{
    CAShapeLayer *shapeLine = [[CAShapeLayer alloc]init];
    shapeLine.strokeColor = [UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000].CGColor;
    shapeLine.lineWidth = 2.0;
    [self.layer addSublayer:shapeLine];
    shapeLine.path = _bottomLinePath.CGPath;
    [CATransaction begin];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue   = @1.0f;
    
    [shapeLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    shapeLine.strokeEnd = 1.0;
    
    [CATransaction commit];
    
    [self startMaskAnimation];
}

- (void)startMaskAnimation{
    self.drawMask = YES;
    [self setNeedsDisplay];
    
}

@end
