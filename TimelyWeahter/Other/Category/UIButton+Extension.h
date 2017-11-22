//
//  UIButton+Extension.h
//  SimpleWeather
//
//  Created by TT on 1/4/16.
//  Copyright © 2016 TT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

/**
 *  设置按钮的字体和图片的间距
 *
 *  @param spaceing 间距
 */
- (void)horizontalCenterTitlesAndImages:(CGFloat)spaceing;

//- (void)try_setImageWithURL:(NSURL *)imageURL forState:(UIControlState)state;

- (void)try_setImageWithURLString:(NSString *)urlString forState:(UIControlState)state;

@end
