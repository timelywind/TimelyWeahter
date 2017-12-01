//
//  YUSetNotificationController.m
//  TimelyWeahter
//
//  Created by caiyi on 2017/11/30.
//

#import "YUSetNotificationController.h"
#import "PreConfig.h"
#import "SHSetDateViewController.h"
#import "UIView+Extension.h"
#import "SHSpeechManager.h"
#import "YUPickerView.h"
#import "UIImage+Color.h"
#import "YUCustomHud.h"

@interface YUSetNotificationController () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isDatePickerPop;
}
@property (strong, nonatomic) UIView *footerView;

@property (weak, nonatomic) IBOutlet UISwitch *speechSwich;
/** 重复日 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic, weak) UIDatePicker *datePicker;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, weak) UIBarButtonItem *rightSaveButton;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (nonatomic, weak) YUPickerView *pickerView;

@end

@implementation YUSetNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WColorRGBA(245, 245, 245, 1);
    self.title = @"设置通知";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSpeechInfo:)];
    self.navigationItem.rightBarButtonItem = item;
    item.tintColor = [UIColor whiteColor];
    _rightSaveButton = item;
    
    // tableView 分割线的设置
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    // footer
    self.tableView.tableFooterView = self.footerView;
    
    // 配置初始化信息
    [self configStatus];
 
}

// 保存按钮点击
- (void)saveSpeechInfo:(UIButton *)sender
{
    sender.enabled = NO;
    
    [YUCustomHud showHudWithText:@"保存成功" delay:1];
    [self saveConfigSpeech];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 关闭datePicker
    [self closeDatePicker];
}

// 配置初始化信息
- (void)configStatus
{
    // 设置时间
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *timeStr = [ud objectForKey:@"SHSpeechTime"];
    if (!timeStr) {
        timeStr = @"08:00";
    }
    self.timeLabel.text = timeStr;
    
    NSArray *tempArr = [ud objectForKey:@"SHSelectedWeekDay"];
    if (tempArr) {
        self.weekdayArray = tempArr;
    } else {
        self.weekdayArray = @[@{@"weekDay":@"每周一", @"isSelected" : @1},
                              @{@"weekDay":@"每周二", @"isSelected" : @1},
                              @{@"weekDay":@"每周三", @"isSelected" : @1},
                              @{@"weekDay":@"每周四", @"isSelected" : @1},
                              @{@"weekDay":@"每周五", @"isSelected" : @1},
                              @{@"weekDay":@"每周六", @"isSelected" : @0},
                              @{@"weekDay":@"每周日", @"isSelected" : @0},
                              ];
    }
    
    [self.tableView reloadData];
}


// 保存并配置
- (void)saveConfigSpeech
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    // 保存时间
    [ud setObject:self.timeLabel.text forKey:@"SHSpeechTime"];
    
    // 保存星期
    [ud setObject:self.weekdayArray forKey:@"SHSelectedWeekDay"];
    [ud synchronize];
    
    // 注册本地通知
    [SHSpeechManager registerNotificationWithWeekArray:self.weekdayArray time:self.timeLabel.text];
    
    // 关闭datePicker
    [self closeDatePicker];
}

- (void)tapClick:(UITapGestureRecognizer *)gesturer
{
    // 关闭datePicker
    [self closeDatePicker];
}

// 开关按钮
- (IBAction)swichClick:(UISwitch *)sender {
    // 关闭datePicker
    [self closeDatePicker];
    
    [self.tableView reloadData];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(sender.on) forKey:@"SHSpeechSwitchStatus"];
    [ud synchronize];
    
    self.rightSaveButton.enabled = NO;
    
    NSString *tips = @"已关闭";
    if (!sender.on) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    } else {
        [self saveConfigSpeech];
        tips = @"已开启";
    }
}

#pragma mark - TableView 代理、数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.speechSwich.on ? 3 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!(indexPath.section == 1 && indexPath.row == 1)) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        // 关闭datePicker
        [self closeDatePicker];
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 设置周几
            SHSetDateViewController *setDateVC = [[SHSetDateViewController alloc] init];
            setDateVC.selectedArray = self.weekdayArray.mutableCopy;
            [self.navigationController pushViewController:setDateVC animated:YES];
            setDateVC.hidesBottomBarWhenPushed = YES;
        } else if (indexPath.row == 1) {
            
            [self closeSecondPicker];
            
            // 设置时间
            if (!_isDatePickerPop) {
                NSDate *date = [NSDate date];
                NSString *dateStr = self.timeLabel.text;
                if (dateStr) {
                    date = [self.dateFormatter dateFromString:dateStr];
                }
                [self.datePicker setDate:date];
                [UIView animateWithDuration:0.3 animations:^{
                    self.datePicker.transform = CGAffineTransformMakeTranslation(0, -200 * TRYScreenWScale);
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.datePicker.transform = CGAffineTransformIdentity;
                }];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            }
            
            _isDatePickerPop = !_isDatePickerPop;
        }
    } else if (indexPath.section == 2) {
        
        [self closeDatePicker];
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (CGAffineTransformEqualToTransform(self.pickerView.transform, CGAffineTransformIdentity)) {
            transform = CGAffineTransformMakeTranslation(0, - self.pickerView.bounds.size.height);
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.pickerView.transform = transform;
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return [super tableView:tableView heightForFooterInSection:section];
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60 * TRYScreenWScale;
    } else if (indexPath.section == 1) {
        return 50 * TRYScreenWScale;
    } else {
        return 50 * TRYScreenWScale;
    }
    
}

#pragma mark --**************** setter and getter

- (void)setWeekdayArray:(NSArray *)weekdayArray
{
    _weekdayArray = weekdayArray;
    
    NSMutableString *mutStr = [NSMutableString stringWithString:@"周"];
    for (NSDictionary *dict in weekdayArray) {
        
        if ([dict[@"isSelected"] boolValue]) {
            [mutStr appendFormat:@"%@、",dict[@"weekDay"]];
        }
    }
    
    [mutStr deleteCharactersInRange:NSMakeRange(mutStr.length - 1, 1)];
    
    NSString *dateStr = [mutStr stringByReplacingOccurrencesOfString:@"每周" withString:@""];
    if ([dateStr isEqualToString:@""]) {
        dateStr = [NSMutableString stringWithString:@"仅一次"];
    } else if ([dateStr isEqualToString:@"周一、二、三、四、五"]) {
        dateStr = [NSMutableString stringWithString:@"工作日"];
    } else if ([dateStr isEqualToString:@"周一、二、三、四、五、六、日"]) {
        dateStr = [NSMutableString stringWithString:@"每天"];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSArray *tempArr = [ud objectForKey:@"SHSelectedWeekDay"];
    if (tempArr && ![tempArr isEqualToArray:weekdayArray]) {
        self.rightSaveButton.enabled = YES;
    }
    
    self.dateLabel.text = dateStr;
}

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"HH:mm"];
    }
    return _dateFormatter;
}

#pragma mark -----------------------  datePicker

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeTime;
        datePicker.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:datePicker];
        datePicker.frame = CGRectMake(0, self.view.bounds.size.height, YUScreenW, 200 * TRYScreenWScale);
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        _datePicker = datePicker;
    }
    return _datePicker;
}
// 设置时间
- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSString *dateString = [self.dateFormatter stringFromDate:datePicker.date];
    self.timeLabel.text = dateString;
    if (![dateString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"SHSpeechTime"]]) {
        self.rightSaveButton.enabled = YES;
    }
    
}

// 关闭datePicker
- (void)closeDatePicker
{
    if (_isDatePickerPop) {
        [UIView animateWithDuration:0.2 animations:^{
            self.datePicker.transform = CGAffineTransformIdentity;
        }];
        
        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:tmpIndexPath];
        [self.tableView deselectRowAtIndexPath:tmpIndexPath animated:NO];
        cell.highlighted = !_isDatePickerPop;
        _isDatePickerPop = !_isDatePickerPop;
    }
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        UIView *footerView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [footerView addGestureRecognizer:tap];
        footerView.height = 300 * TRYScreenWScale;
        _footerView = footerView;
    }
    return _footerView;
}

#pragma mark -----------------------  pickerView

- (YUPickerView *)pickerView
{
    if (_pickerView == nil) {
        YUPickerView *pickerView = [[YUPickerView alloc] init];
        [self.view addSubview:pickerView];
        pickerView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 220 * TRYScreenWScale);
        _pickerView = pickerView;
        
        __weak typeof(self) weakSelf = self;
        [pickerView setValueChangedBlock:^(YUPickerView *pickerView) {
            [weakSelf configSecondValueWithPickerView:pickerView];
        }];

        [pickerView.pickerView reloadAllComponents];
        
        [pickerView setSureButtonBlock:^(NSInteger tag) {
            [weakSelf handlePickerViewActionWithTag:tag];
        }];
    }
    return _pickerView;
}

- (void)configSecondValueWithPickerView:(YUPickerView *)pickerView
{
    NSString *repeatStr = ([pickerView.isRepeat integerValue] == 0) ? @"" : @"，重复";
    self.secondLabel.text = [NSString stringWithFormat:@"%lds后提醒%@", [pickerView.min integerValue] * 60 + [pickerView.second integerValue], repeatStr];
}

- (void)handlePickerViewActionWithTag:(NSInteger)tag
{
    [SHSpeechManager cancelSecondLocalNotification];
    if (tag == 0) {
        self.secondLabel.text = @"暂未设置";
    } else {
        [SHSpeechManager registerNotificationAfterDelay:[_pickerView.min integerValue] * 60 + [_pickerView.second integerValue] isRepeat: [_pickerView.isRepeat integerValue]];
        [YUCustomHud showHudWithText:@"设置成功" delay:1.2];
    }
    
    [self closeSecondPicker];
}

- (void)closeSecondPicker
{
    if (!CGAffineTransformEqualToTransform(self.pickerView.transform, CGAffineTransformIdentity)) {
        [UIView animateWithDuration:0.2 animations:^{
            self.pickerView.transform = CGAffineTransformIdentity;
        }];
    }
}


@end
