//
//  YUWeatherDataCacheHelper.h
//  TimelyWeahter
//
//  Created by caiyi on 2017/12/1.
//

#import <Foundation/Foundation.h>

@interface YUWeatherDataCacheHelper : NSObject

+ (void)setWeatherDataCache:(id)cache;

+ (id)getMainWeatherDataCache;

@end
