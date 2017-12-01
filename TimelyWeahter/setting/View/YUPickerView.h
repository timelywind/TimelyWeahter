//
//  YUPickerView.h
//  TimelyWeahter
//
//  Created by caiyi on 2017/12/1.
//

#import <UIKit/UIKit.h>

@interface YUPickerView : UIView

@property (nonatomic, weak) UIPickerView *pickerView;

@property (nonatomic, copy) void (^sureButtonBlock)(NSInteger tag);

@property (nonatomic, copy) void (^valueChangedBlock)(YUPickerView *pickerView);

@property (nonatomic, copy) NSString *isRepeat;

@property (nonatomic, copy) NSString *min;

@property (nonatomic, copy) NSString *second;

@end
