//
//  NSString+Json.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14-6-13.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JsonValue)
/**
 *  @brief  JSON字符串转成数组或者字典
 *
 *  @return jsonValue
 */
-(id) jsonValue;
@end
