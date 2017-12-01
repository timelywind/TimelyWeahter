//
//  YUNetHelp.m
//
//  Created by timely on 15/2/20.
//  Copyright © 2016年 timely. All rights reserved.
//

#import "YUNetHelp.h"
#import "NSDate+Formatter.h"

static YUNetHelp *_shareManager;

@implementation YUNetHelp
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // AFHTTPSessionManager 单例对象，可以在程序短时间内发起多个请求时，降低系统开销
        _shareManager = [[super allocWithZone:NULL] initWithBaseURL:[NSURL URLWithString:@"https://route.showapi.com"]];
        _shareManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _shareManager.requestSerializer.timeoutInterval = 10;
        _shareManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _shareManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
//        [self isReachToWeb];
    });
    
    return _shareManager;
}


//ExtraUrl 为主地址后面的一系列参数
+ (void)POSTWithExtraUrl:(NSString *)url andParam:(NSDictionary *)params andComplete:(void (^)(BOOL success, id result))complete {
    [[self shareManager] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(NO,error.localizedDescription);
    }];
    
}

+ (void)GETWithExtraUrl:(NSString *)url andParam:(NSDictionary *)params andComplete:(void (^)(BOOL success, id result))complete; {
    [[self shareManager] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(NO,error.localizedDescription);
    }];
}



- (void)isReachToWeb {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"使用其他网络");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没有网络" message:@"您的手机网络出现异常！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAlert];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络状态" message:@"您当前使用的是3G/4G网络" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"请您谨慎使用" style:UIAlertActionStyleDestructive handler:nil];
                [alert addAction:cancelAlert];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    
                });
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络状态" message:@"您当前使用的是WiFi" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"请您放心上网" style:UIAlertActionStyleDestructive handler:nil];
                [alert addAction:cancelAlert];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    
                });
             //   [SVProgressHUD showInfoWithStatus:@"您当前使用的是WiFi"];
                break;
            }
        }
        
    }];
    [_shareManager.reachabilityManager startMonitoring];
}



+ (void)requestWeatherForCity:(NSString *)cityName complete:(void (^)(BOOL success, id result))complete
{
    
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"yyyyMMddHHmmss"];
    
    NSString *url = @"9-2";
    NSString *secret = @"5cc4274ccad348ba86b53e5971082a6b";
    //    NSString *sign = [NSString stringWithFormat:@"area%@needIndex1needMoreDay1showapi_appid16424showapi_timestamp%@%@",area,nowDate,secret];
    //    NSString *md5Sign = [sign md532BitLower];
    
    NSDictionary *params = @{
                             @"area":cityName ? : @"",
                             @"needIndex":@1,
                             @"needMoreDay":@1,
                             @"showapi_appid":@"16424",
                             @"showapi_timestamp":nowDate,
                             @"showapi_sign":secret,
                             };
    
    [[self shareManager] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(NO,error.localizedDescription);
    }];
    
}






























@end
