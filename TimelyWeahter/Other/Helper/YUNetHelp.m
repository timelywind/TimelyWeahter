//
//  YUNetHelp.m
//  Jianzhiweishi
//
//  Created by timely on 15/2/20.
//  Copyright © 2016年 timely. All rights reserved.
//

#import "YUNetHelp.h"

static YUNetHelp *_shareManager;

@implementation YUNetHelp
// 16424   5cc4274ccad348ba86b53e5971082a6b
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // AFHTTPSessionManager 单例对象，可以在程序短时间内发起多个请求时，降低系统开销
        _shareManager = [[super allocWithZone:NULL] initWithBaseURL:[NSURL URLWithString:@"https://route.showapi.com"]];// 这里使用 BaseUrl ，是让 AFNetworking 减少每次请求服务器时候，提升查找目标服务器地址的速度，而且这里建议直接使用 ip 地址。
        // 设置网络请求 SSL 功能，使用（HTTPS）时开启
        //		_shareManager.securityPolicy = [AFSecurityPolicy   policyWithPinningMode:AFSSLPinningModeNone];
        // 设置请求内容的序列化方式
        _shareManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 设置网络超时的时间，10秒。
        _shareManager.requestSerializer.timeoutInterval = 10;
        // 设置服务器返回数据的序列化方式
        _shareManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 设置可接受的服务器返回数据的格式
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


































@end
