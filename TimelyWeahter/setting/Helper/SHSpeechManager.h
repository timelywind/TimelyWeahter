//
//  SHSpeechManager.h

//

#import <UIKit/UIKit.h>

@interface SHSpeechManager : NSObject



//+ (SHSpeechManager *)shareManager;

/**
 *  注册本地通知
 */
+ (void)registerNotificationWithWeekArray:(NSArray *)weekArray time:(NSString *)time;


+ (void)registerNotificationAfterDelay:(NSTimeInterval)delay isRepeat:(BOOL)isRepeat;


+ (void)cancelSecondLocalNotification;

@end
