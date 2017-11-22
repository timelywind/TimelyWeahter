//
//  TRYBaseViewController.h
//  Lottery
//
//  Created by caiyi on 2017/11/1.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRYBaseViewController : UIViewController


@property (nonatomic, weak) UIView *customNavigationBar;

//@property (nonatomic, assign) BOOL enabelPopGestureRecognizer;/* 是否开启右滑手势 默认开启*/
@property (nonatomic, assign) BOOL showNavigationBar;

@property (nonatomic, weak) UIButton *leftButton;

@property (nonatomic, weak) UIButton *rightButton;

@property (nonatomic, copy) NSString *titleStr;

- (void)defaultLeftButtonClick;


- (void)defaultRightButtonClick;

@end
