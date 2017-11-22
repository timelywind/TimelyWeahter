//
//  CustomNavigationBar.h
//  Lottery
//
//  Created by caiyi on 2017/11/22.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationBar : UIView

@property (nonatomic, assign) BOOL showNavigationBar;

@property (nonatomic, weak) UIButton *leftButton;

@property (nonatomic, weak) UIButton *rightButton;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, weak) id delegate;


@end
