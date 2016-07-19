//
//  NSString+MD5.m
//  NSString With MD5
//
//  Created by snow on 14-3-12.
//  Copyright (c) 2014年 snow. All rights reserved.
//  16位其实就是32位去除头和尾各8位

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

/**
 *  把字符串加密成32位小写md5字符串
 *
 *  @return 加密后的32位小写md5字符串
 */
- (NSString *)md532BitLower {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

/**
 *  把字符串加密成32位大写md5字符串
 *
 *  @return 加密后的32位大写md5字符串
 */
- (NSString *)md532BitUpper {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

@end
