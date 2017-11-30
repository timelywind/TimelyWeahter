//
//  SHSpeechManager.h

//

#import <UIKit/UIKit.h>

@interface SHSpeechManager : NSObject



+ (SHSpeechManager *)shareManager;

/**
 *  注册本地通知
 */
+ (void)registerNotificationWithWeekArray:(NSArray *)weekArray time:(NSString *)time;


@end
