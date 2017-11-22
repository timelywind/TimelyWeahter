//
//  TRYBaseTableViewController.m
//  Lottery
//
//  Created by caiyi on 2017/11/6.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import "TRYBaseTableViewController.h"
#import "PreConfig.h"

@interface TRYBaseTableViewController ()

@end

@implementation TRYBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
}

- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat top = kStatusBarHeight + kNavBarHeight;
    
    TRYBaseTableView *tableView = [[TRYBaseTableView alloc] initWithFrame:CGRectMake(0, top, self.view.bounds.size.width, self.view.bounds.size.height - top) style:UITableViewStyleGrouped];
    
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    self.tableView = tableView;
    
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
