//
//  TRYBaseTableViewController.h
//  Lottery
//
//  Created by caiyi on 2017/11/6.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import "TRYBaseViewController.h"
#import "TRYBaseTableView.h"

@interface TRYBaseTableViewController : TRYBaseViewController  <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TRYBaseTableView *tableView;

@end
