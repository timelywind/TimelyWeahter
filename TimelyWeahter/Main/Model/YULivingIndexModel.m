//
//  YULivingIndexModel.m
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "YULivingIndexModel.h"

@implementation YULivingIndexModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"clothes_desc" : @"clothes.desc",
             @"clothes_title" : @"clothes.title",
             @"ls_desc" : @"ls.desc",
             @"ls_title" : @"ls.title",
             @"cold_desc" : @"cold.desc",
             @"cold_title" : @"cold.title",
             @"cl_desc" : @"cl.desc",
             @"cl_title" : @"cl.title",
             @"travel_desc" : @"travel.desc",
             @"travel_title" : @"travel.title",
             @"pj_desc" : @"pj.desc",
             @"pj_title" : @"pj.title",
             @"dy_desc" : @"dy.desc",
             @"dy_title" : @"dy.title"
             };
}

@end
