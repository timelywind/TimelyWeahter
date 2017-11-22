//
//  UIImageView+loadImage.h
//  Lottery
//
//  Created by caiyi on 2017/11/8.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (loadImage)

- (void)try_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage completed:(void(^)(UIImage *image))completed;

- (void)try_setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholder;

@end
