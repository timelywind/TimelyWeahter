//
//  SHSetDateViewController.m
//  TimelyWeahter
//
//  Created by weahter on 16/10/8.
//  Copyright © 2016年 tt. All rights reserved.
//

#import "SHSetDateViewController.h"
#import "PreConfig.h"
#import "SHWeekDayTableViewCell.h"
#import "YUSetNotificationController.h"

static NSString * const SHWeekDayTableViewCellId = @"SHWeekDayTableViewCell";

@interface SHSetDateViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation SHSetDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"请选择";
    self.view.backgroundColor = WColorRGB(245, 245, 245);
//    self.navBgColor = SHColor(9, 47, 70, 1.0);
    // 添加子视图
    [self setupSubViews];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];

    for (YUSetNotificationController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[YUSetNotificationController class]]) {
            vc.weekdayArray = [NSArray arrayWithArray:self.selectedArray];
        }
    }
}



// 添加子视图
- (void)setupSubViews
{
    // 创建并设置tableview
    CGFloat offsetY = 15;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, offsetY, YUScreenW, self.view.bounds.size.height - offsetY)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.rowHeight = 44 * TRYScreenWScale;
    
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    // 注册cell
    [self.tableView registerClass:[SHWeekDayTableViewCell class] forCellReuseIdentifier:SHWeekDayTableViewCellId];
    
    tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - TableView 代理、数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHWeekDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHWeekDayTableViewCellId];
    cell.dataDict = self.selectedArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选中或取消
    SHWeekDayTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dict = [self.selectedArray[indexPath.row] mutableCopy];
    cell.isSelected = !cell.isSelected;
    [dict setObject:@(cell.isSelected) forKey:@"isSelected"];
    [self.selectedArray removeObjectAtIndex:indexPath.row];
    [self.selectedArray insertObject:dict atIndex:indexPath.row];
}

@end
