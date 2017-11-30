//
//  TRYRefreshHeader.m
//  Lottery
//
//  Created by caiyi on 2017/11/3.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import "TRYRefreshHeader.h"
#import "PreConfig.h"

@implementation TRYRefreshHeader

//- (void)prepare
//{
//    [super prepare];
//
//    //根据拖拽的情况自动切换透明度
//    self.automaticallyChangeAlpha = YES;
//    self.lastUpdatedTimeLabel.hidden = YES;
//
//    self.stateLabel.font = [UIFont systemFontOfSize:12];
//    self.stateLabel.textAlignment = NSTextAlignmentLeft;
//    self.stateLabel.textColor = WColorRGB(200, 200, 200);
//
//    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    [self setTitle:@"释放刷新" forState:MJRefreshStatePulling];
//    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//
//    self.labelLeftInset = 10;
//}
//
//
//
///**
// *  摆放子控件
// */
//- (void)placeSubviews
//{
//    [super placeSubviews];
//
//    // stateLabel
//    self.stateLabel.mj_x = CGRectGetMaxX(self.arrowView.frame) + 15;
//    self.stateLabel.mj_y = CGRectGetMinY(self.arrowView.frame);
//    self.stateLabel.mj_w = self.mj_w/2;
//    self.stateLabel.mj_h = CGRectGetHeight(self.arrowView.frame);
//}

-(void)placeSubviews
{
    [super placeSubviews];
    
    self.gifView.frame = CGRectMake(0, 5, self.bounds.size.width, self.bounds.size.height * 7/12.f);
    self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    self.stateLabel.mj_y = self.gifView.mj_y + self.gifView.mj_h + 3;
    self.stateLabel.mj_h = self.bounds.size.height * 5 / 12 - 5;
}

- (void)prepare{
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.font = [UIFont systemFontOfSize:10];
    self.stateLabel.textColor = [UIColor whiteColor];
    
    NSInteger imgCount = 5;
    NSMutableArray *imgs = [NSMutableArray arrayWithCapacity:imgCount];
    for (int i = 0; i < imgCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_gif_%02d", i + 1]];
        if (image) {
            [imgs addObject:image];
        }
    }

    [self setImages:imgs duration:0.03 * imgCount forState:MJRefreshStateIdle];
    [self setImages:imgs duration:0.03 * imgCount forState:MJRefreshStatePulling];
    [self setImages:imgs duration:0.03 * imgCount forState:MJRefreshStateRefreshing];
    [self setTitle:@"释放立即刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
}


@end

