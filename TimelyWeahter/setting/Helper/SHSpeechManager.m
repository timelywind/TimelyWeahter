//
//  SHSpeechManager.m

//

#import "SHSpeechManager.h"

//static SHSpeechManager *speechManager = nil;

@implementation SHSpeechManager

//+ (SHSpeechManager *)shareManager{
//
//    return [[self alloc] init];
//}
//
//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        speechManager = [super allocWithZone:zone];
//
//    });
//    return speechManager;
//}


#pragma mark --****************   设置本地通知
// 延时多少秒通知
+ (void)registerNotificationAfterDelay:(NSTimeInterval)delay isRepeat:(BOOL)isRepeat
{
    UILocalNotification *notification = [self notification];
    NSInteger repeatInterval = 0;
    if (isRepeat) {
        repeatInterval = kCFCalendarUnitMinute;
    }
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"YUSecond" forKey:@"YUSecond"];
    notification.userInfo = userDict;
    notification.repeatInterval = repeatInterval;
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


// 设置本地通知
+ (void)registerNotificationWithWeekArray:(NSArray *)weekArray time:(NSString *)time{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // 设置触发通知的时间
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    
    NSInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitQuarter;
    
    comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
    
    comps.hour = [[time substringToIndex:2] integerValue];
    comps.minute = [[time substringFromIndex:3] integerValue];
    comps.second = 0;
    
    long temp = 0;
    long days = 0;
    
    NSInteger index = 0;
    // 循环注册通知
    for (int i = 0; i < weekArray.count; i++) {
        NSDictionary *dict = weekArray[i];
        if ([dict[@"isSelected"] boolValue]) {
            index++;
            
            UILocalNotification *notification = [self notification];
            
            temp = i + 2 - currentComponents.weekday;
            if (i ==  weekArray.count - 1) {
                temp = 1 - currentComponents.weekday;
            }
            
            days = temp >= 0 ? temp : temp + 7;
            
            if (temp == 0) {
                NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"HH:mm"];
                NSString *nowStr = [formatter stringFromDate:[NSDate date]];
                if ([time compare:nowStr] < 0) {
                    days = temp + 7;
                }
            }
            
            NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
            notification.fireDate = newFireDate;
            
            // 执行通知注册
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
        }
    }
    
    // 仅一次的通知
    if (index == 0) {
        
        UILocalNotification *notification = [self notification];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *nowStr = [formatter stringFromDate:[NSDate date]];
        if ([time compare:nowStr] < 0) {
            days = 1;
        } else {
            days = 0;
        }
        notification.repeatInterval = 0;
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
        // 执行通知注册
        notification.fireDate = newFireDate;
//        NSLog(@"fireDate=%@",newFireDate);
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

// 创建通知
+ (UILocalNotification *)notification
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 时区
    notification.timeZone = [NSTimeZone systemTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitWeek;
    //    notification.alertTitle = @"Hello!";
    notification.alertBody =  @"📢 亲，您预约的时间到了，点击查看吧~";
    notification.applicationIconBadgeNumber = 1;

    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"SHLocalKey" forKey:@"SHLocalKey"];
    notification.userInfo = userDict;
    
    return notification;
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                
                break;
            }
        }
    }
}

+ (void)cancelSecondLocalNotification
{
    [self cancelLocalNotificationWithKey:@"YUSecond"];
}

@end
