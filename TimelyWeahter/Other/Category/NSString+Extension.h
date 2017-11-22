//
//  NSString+Extension.h
//  SimpleWeather
//
//  Created by TT on 1/2/16.
//  Copyright © 2016 TT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

- (CGFloat)widthForFont:(UIFont *)font;


- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;


@end
