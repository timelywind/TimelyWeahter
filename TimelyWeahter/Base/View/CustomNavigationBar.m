//
//  CustomNavigationBar.m
//  Lottery
//
//  Created by caiyi on 2017/11/22.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import "CustomNavigationBar.h"
#import "PreConfig.h"

@interface CustomNavigationBar ()

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation CustomNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews];
    }
    return self;
}

// 创建子视图
- (void)setupSubViews
{
    CGFloat leftButtonW = 60;
//    CGFloat height = kStatusBarHeight + kNavBarHeight;
//    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YUScreenW, height)];
//    [self addSubview:navigationBar];
    self.backgroundColor = TRYGlobalColor;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:leftButton];
    //        UIImage *image = [[UIImage imageNamed:@"back wihte"] imageWithColor:[UIColor blackColor]];
    //        [leftButton setImage:image forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, kStatusBarHeight, leftButtonW, kNavBarHeight);
    _leftButton = leftButton;
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(leftButtonW, kStatusBarHeight, YUScreenW - leftButtonW * 2, kNavBarHeight)];
    [self addSubview:centerView];
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    [centerView addSubview:titleLabel];
    _titleLabel = titleLabel;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = centerView.bounds;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:rightButton];
    rightButton.frame = CGRectMake(CGRectGetMaxX(centerView.frame), kStatusBarHeight, leftButtonW, kNavBarHeight);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //        [rightButton setTitleColor:try_colorForHex(@"#262A32") forState:UIControlStateNormal];
    _rightButton = rightButton;
}


- (void)leftButtonClick
{
    if ([_delegate respondsToSelector:@selector(defaultLeftButtonClick)]) {
        [_delegate performSelector:@selector(defaultLeftButtonClick)];
    }
}

- (void)rightButtonClick
{
    if ([_delegate respondsToSelector:@selector(defaultRightButtonClick)]) {
        [_delegate performSelector:@selector(defaultRightButtonClick)];
    }
}

@end
