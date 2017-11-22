//
//  NSDate+Extenion.h
//  SimpleWeather
//
//  Created by TT on 1/7/16.
//  Copyright © 2016 TT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extenion)

@property (nonatomic, readonly) NSInteger weekday;

- (NSString *)stringWithFormat:(NSString *)format;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSString*)getChineseCalendarWithDate:(NSDate *)date;
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
@end
