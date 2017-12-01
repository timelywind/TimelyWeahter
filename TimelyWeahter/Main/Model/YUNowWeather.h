//
//  YUNowWeather.h
//  TimelyWeahter
//
//  Created by timely on 15/3/5.
//  Copyright © 2016年 timely. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YUNowWeather : NSObject

@property (nonatomic, copy) NSString *updateTime;
/**  */
@property (nonatomic,copy) NSString *aqi;
/**  */
@property (nonatomic,copy) NSString *sd;
/**  */
@property (nonatomic,copy) NSString *temperature;
/**  */
@property (nonatomic,copy) NSString *temperature_time;
/**  */
@property (nonatomic,copy) NSString *weather;
/**  */
@property (nonatomic,copy) NSString *weather_pic;
/**  */
@property (nonatomic,copy) NSString *wind_direction;
/**  */
@property (nonatomic,copy) NSString *wind_power;

@property (nonatomic,copy) NSString *city;


@end
