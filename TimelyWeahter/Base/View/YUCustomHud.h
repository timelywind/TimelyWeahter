//
//  YUCustomHud.h
//  TimelyWeahter
//
//  Created by caiyi on 2017/12/1.
//

#import <UIKit/UIKit.h>

@interface YUCustomHud : UIView

+ (void)showHudWithText:(NSString *)text delay:(NSTimeInterval)duration;

+ (void)showInView:(UIView *)superView;

+ (void)dismiss;

@end
