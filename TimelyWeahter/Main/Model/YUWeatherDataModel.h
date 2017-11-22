//
//  YUWeatherDataModel.h
//  TimelyWeahter
//
//  Created by timely on 15/3/4.
//  Copyright © 2016年 timely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YUWeatherDataModel : NSObject
// index
/**  */
@property (nonatomic,copy) NSString *air_press;
/**  */
@property (nonatomic,copy) NSString *day;
/**  */
@property (nonatomic,copy) NSString *day_weather;
/**  */
@property (nonatomic,copy) NSString *day_air_temperature;
/**  */
@property (nonatomic,copy) NSString *day_weather_pic;
/**  */
@property (nonatomic,copy) NSString *day_wind_direction;
/**  */
@property (nonatomic,copy) NSString *day_wind_power;
/**  */
@property (nonatomic,copy) NSString *jiangshui;
/**  */
@property (nonatomic,copy) NSString *night_air_temperature;
/**  */
@property (nonatomic,copy) NSString *night_weather;
/**  */
@property (nonatomic,copy) NSString *night_weather_pic;

@property (nonatomic,copy) NSString *night_wind_direction;
/**  */
@property (nonatomic,copy) NSString *night_wind_power;
/**  */
@property (nonatomic,copy) NSString *sun_begin_end;
/**  */
@property (nonatomic,copy) NSString *weekday;
/**  */
@property (nonatomic,copy) NSString *ziwaixian;


/**  */
@property (nonatomic,assign) CGFloat centerX;

@end
