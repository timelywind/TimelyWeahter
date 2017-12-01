//
//  YUCustomHud.m
//  TimelyWeahter
//
//  Created by caiyi on 2017/12/1.
//

#import "YUCustomHud.h"

static YUCustomHud *_sharedHud;

@interface YUCustomHud ()

/** 提示内容Label */
@property (nonatomic, weak) UILabel *tipLabel;

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;

@end

@implementation YUCustomHud

// MARK: ----------------------- show text

+ (YUCustomHud *)sharedHud {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _sharedHud = [[YUCustomHud alloc] initWithFrame: CGRectMake((size.width - 80) / 2, (size.height - 70)/2, 80, 70)];
    });
    return _sharedHud;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.color = [UIColor whiteColor];
        [self addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    
    return _indicatorView;
}

+ (void)showInView:(UIView *)superView
{
    YUCustomHud *sharedHud = [YUCustomHud sharedHud];
    sharedHud.alpha = 1.0;
    sharedHud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.60];
    CGSize size = superView.bounds.size;
    if (size.width <= 0) {
        size = [UIScreen mainScreen].bounds.size;
    }
    CGFloat hudWidth = 120;
    sharedHud.frame = CGRectMake((size.width - hudWidth) / 2, (size.height - hudWidth - 25) / 2, hudWidth, hudWidth - 25);
    sharedHud.tipLabel.text = @"加载中...";
    
    [superView addSubview:sharedHud];
    sharedHud->_indicatorView.hidden = YES;
    [sharedHud.indicatorView startAnimating];
}

+ (void)dismiss
{
    if (_sharedHud) {
        [_sharedHud->_indicatorView stopAnimating];
        [_sharedHud removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tipLabel.frame = self.bounds;
    
    if (_indicatorView && !_indicatorView.hidden) {
        CGFloat indicatorViewWidth = 35;
        _indicatorView.frame = CGRectMake((self.bounds.size.width - indicatorViewWidth) / 2, (self.bounds.size.height - indicatorViewWidth - 22) / 2, indicatorViewWidth, indicatorViewWidth);
        _tipLabel.frame = CGRectMake(0, CGRectGetMaxY(_indicatorView.frame) + 5, self.bounds.size.width, 25);
    }
    
}

// MARK: ----------------------- show status

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.680];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        self.alpha = 0;
        
        // 创建子视图
        [self setupSubViews];
        
    }
    return self;
}

- (void)dealloc
{
    
}

// 创建子视图
- (void)setupSubViews
{
    // 提示Label
    UILabel *tipLabel = [[UILabel alloc] init];
    [self addSubview:tipLabel];
    _tipLabel = tipLabel;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:15.0];
    tipLabel.textAlignment = NSTextAlignmentCenter;
}

// 显示
+ (void)showHudWithText:(NSString *)text delay:(NSTimeInterval)duration
{
    YUCustomHud *hud = [[YUCustomHud alloc] initWithFrame:CGRectZero];
    hud.tipLabel.text = text;
    hud->_indicatorView.hidden = YES;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:hud];
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(window.bounds.size.width - 80, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:hud.tipLabel.font} context:nil].size;
    hud.frame = CGRectMake(0, 0, size.width + 40, 50);
    hud.center = window.center;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        hud.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{
                hud.alpha = 0;
            } completion:^(BOOL finished) {
                [hud removeFromSuperview];
            }];
        });
    }];
}


@end
