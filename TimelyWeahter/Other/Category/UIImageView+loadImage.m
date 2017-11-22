//
//  UIImageView+loadImage.m
//  Lottery
//
//  Created by caiyi on 2017/11/8.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import "UIImageView+loadImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (loadImage)

- (void)try_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage completed:(void(^)(UIImage *image))completed {
    
    [self sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (completed) {
            completed(image);
        }
    }];
    
}

- (void)try_setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithURL:imageURL placeholderImage:placeholder];
}

@end
