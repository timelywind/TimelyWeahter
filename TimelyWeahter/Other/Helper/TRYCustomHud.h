//
//  NOEECustomHud.h
//  Lottery
//
//  Created by caiyi on 2017/10/9.
//  Copyright © 2017年 Hanrovey-9188. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRYCustomHud : UIView

/** 提示内容Label */
@property (weak, nonatomic) UILabel *tipLabel;

+ (void)showHudWithTipText:(NSString *)tipText delay:(NSTimeInterval)duration;

@end
