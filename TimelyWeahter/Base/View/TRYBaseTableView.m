//
//  TRYBaseTableView.m
//  Lottery
//
//  Created by caiyi on 2017/11/1.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import "TRYBaseTableView.h"

@implementation TRYBaseTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ([super initWithFrame:frame style:style]) {
        [self setupSubViews];
    }
    return self;
}

// 创建子视图
- (void)setupSubViews
{
    [self adaptive_iOS_11];
}

// 适配iOS 11
- (void)adaptive_iOS_11
{
#ifdef __IPHONE_11_0
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
#endif
    
}

@end
