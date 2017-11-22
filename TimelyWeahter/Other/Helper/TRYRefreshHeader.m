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

- (void)prepare
{
    [super prepare];
    
    //根据拖拽的情况自动切换透明度
    self.automaticallyChangeAlpha = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.stateLabel.textAlignment = NSTextAlignmentLeft;
    self.stateLabel.textColor = WColorRGB(200, 200, 200);
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    
    self.labelLeftInset = 10;
}



/**
 *  摆放子控件
 */
- (void)placeSubviews
{
    [super placeSubviews];
    
    // stateLabel
    self.stateLabel.mj_x = CGRectGetMaxX(self.arrowView.frame) + 15;
    self.stateLabel.mj_y = CGRectGetMinY(self.arrowView.frame);
    self.stateLabel.mj_w = self.mj_w/2;
    self.stateLabel.mj_h = CGRectGetHeight(self.arrowView.frame);
}

@end

