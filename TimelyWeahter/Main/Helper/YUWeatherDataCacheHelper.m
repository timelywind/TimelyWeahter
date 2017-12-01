//
//  YUWeatherDataCacheHelper.m
//  TimelyWeahter
//
//  Created by caiyi on 2017/12/1.
//

#import "YUWeatherDataCacheHelper.h"

static NSString * const YUMainWeatherCacheKey = @"YUMainWeatherCacheKey";

@implementation YUWeatherDataCacheHelper

+ (void)setDataCache:(id)cache key:(NSString *)key
{
    if ([cache respondsToSelector:@selector(writeToFile:atomically:)]) {
        NSDictionary *tmpDict = cache;
        [tmpDict writeToFile:[self cachePathWithKey:key] atomically:YES];
    }
}

+ (id)getDataCacheWithKey:(NSString *)key
{
    return [NSDictionary dictionaryWithContentsOfFile: [self cachePathWithKey:key]];
}

+ (NSString *)cachePathWithKey:(NSString *)key
{
    NSArray *arrCachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    return [arrCachesPaths.firstObject stringByAppendingPathComponent: [key stringByAppendingString:@".plist"]];
}

+ (void)setWeatherDataCache:(id)cache
{
    [self setDataCache:cache key:YUMainWeatherCacheKey];
}

+ (id)getMainWeatherDataCache
{
    return [self getDataCacheWithKey:YUMainWeatherCacheKey];
}

@end
