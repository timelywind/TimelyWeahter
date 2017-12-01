//
//  YUPickerView.m
//  TimelyWeahter
//
//  Created by caiyi on 2017/12/1.
//

#import "YUPickerView.h"
#import "PreConfig.h"

@interface YUPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *secondArray;

@property (nonatomic, copy) NSArray *repeatArray;

@property (nonatomic, strong) NSMutableArray *sureButtonArray;

@end

@implementation YUPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setupSubViews];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// 创建子视图
- (void)setupSubViews
{
    NSArray *titles = @[@"取消", @"确定"];
    _sureButtonArray = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        button.tag = 1000 + i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:WColorRGB(53, 149, 249) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget: self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_sureButtonArray addObject:button];
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    _pickerView = pickerView;
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self addSubview:pickerView];
    
    _secondArray = [NSMutableArray array];
    for (int i = 0; i < 60; i++) {
        NSString *string = [NSString stringWithFormat:@"%@", @(i)];
        [_secondArray addObject:string];
    }
    _repeatArray = @[@"0", @"1"];
    
    _isRepeat = @"0";
    _min = @"0";
    _second = @"0";
}

- (void)sureButtonAction:(UIButton *)button
{
    if (_sureButtonBlock) {
        _sureButtonBlock(button.tag - 1000);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIButton *sureButton = nil;
    for (int i = 0; i < _sureButtonArray.count; i++) {
        sureButton = _sureButtonArray[i];
        CGFloat left = self.bounds.size.width * 0.20;
        if (i == 1) {
            left = self.bounds.size.width - left - 40;
        }
        sureButton.frame = CGRectMake(left, 8, 40, 30);
    }
    
    _pickerView.frame = CGRectMake(0, CGRectGetMaxY(sureButton.frame), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(sureButton.frame));
}

// MARK: -----------------------  UIPickerViewDelegate

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_repeatArray count];
    } else if (component == 1) {
        return [_secondArray count];
    } else {
        return [_secondArray count];
    }
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    return self.bounds.size.width * 0.7 / 3;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _isRepeat = [_repeatArray objectAtIndex:row];
    } else if (component == 1) {
        _min = [_secondArray objectAtIndex:row];
    } else {
        _second = [_secondArray objectAtIndex:row];
    }

    if (_valueChangedBlock) {
        _valueChangedBlock(self);
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_repeatArray objectAtIndex:row];
    } else if (component == 1) {
        return [_secondArray objectAtIndex:row];
    } else {
        return [_secondArray objectAtIndex:row];
    }
}

@end
