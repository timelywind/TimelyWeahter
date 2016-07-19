//
//  UIImage+CalculatedSize.m
//  renqi
//
//  Created by 王广威 on 15/11/7.
//  Copyright © 2015年 王广威. All rights reserved.
//

#import "UIImage+CalculatedSize.h"

@implementation UIImage (CalculatedSize)

- (NSUInteger)calculatedSize {
	return CGImageGetHeight(self.CGImage) * CGImageGetBytesPerRow(self.CGImage);
}

@end
