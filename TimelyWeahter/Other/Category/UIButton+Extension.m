//
//  UIButton+Extension.m
//  SimpleWeather
//
//  Created by TT on 1/4/16.
//  Copyright © 2016 TT. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIButton+WebCache.h"

@implementation UIButton (Extension)

- (void)horizontalCenterTitlesAndImages:(CGFloat)spacing{
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,  0.0, 0.0,  - spacing/2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing/2, 0.0, 0.0);
}

- (void)try_setImageWithURL:(NSURL *)imageURL forState:(UIControlState)state
{
    [self sd_setImageWithURL:imageURL forState:state];
}

- (void)try_setImageWithURLString:(NSString *)urlString forState:(UIControlState)state
{
    if ([urlString containsString:@"http://"]) {
        urlString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }
    
    [self try_setImageWithURL:[NSURL URLWithString: urlString] forState:state];
}

@end
