//
//  NOEECustomHud.m
//  Lottery
//
//  Created by caiyi on 2017/10/9.
//  Copyright © 2017年 Hanrovey-9188. All rights reserved.
//

#import "TRYCustomHud.h"

@interface TRYCustomHud ()


@end

@implementation TRYCustomHud

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.680];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        self.alpha = 0;
        
        // 创建子视图
        [self setupSubViews];
        
    }
    return self;
}

- (void)dealloc
{
    
}

// 创建子视图
- (void)setupSubViews
{
    // 提示Label
    UILabel *tipLabel = [[UILabel alloc] init];
    [self addSubview:tipLabel];
    _tipLabel = tipLabel;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:15.0];
    tipLabel.textAlignment = NSTextAlignmentCenter;
}

// 显示
+ (void)showHudWithTipText:(NSString *)tipText delay:(NSTimeInterval)duration
{
    TRYCustomHud *hud = [[TRYCustomHud alloc] initWithFrame:CGRectZero];
    hud.tipLabel.text = tipText;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:hud];
    
    CGSize size = [tipText boundingRectWithSize:CGSizeMake(window.bounds.size.width - 80, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:hud.tipLabel.font} context:nil].size;
    
    
    hud.frame = CGRectMake(0, 0, size.width + 40, 50);
    hud.center = window.center;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        hud.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.4 animations:^{
                hud.alpha = 0;
            } completion:^(BOOL finished) {
                [hud removeFromSuperview];
            }];
        });
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tipLabel.frame = self.bounds;
}

@end
