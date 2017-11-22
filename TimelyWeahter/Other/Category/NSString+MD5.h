//
//  NSString+MD5.h
//  NSString With MD5
//
//  Created by snow on 14-3-12.
//  Copyright (c) 2014年 snow. All rights reserved.
//	16位其实就是32位去除头和尾各8位

#import <Foundation/Foundation.h>

@interface NSString (MD5)

//把字符串加密成32位小写md5字符串
- (NSString*)md532BitLower;

//把字符串加密成32位大写md5字符串
- (NSString*)md532BitUpper;


@end
