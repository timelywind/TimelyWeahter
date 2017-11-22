//
//  TRYBaseViewController.m
//  Lottery
//
//  Created by caiyi on 2017/11/1.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import "TRYBaseViewController.h"
#import "PreConfig.h"

@interface TRYBaseViewController ()

@property (nonatomic, weak) UILabel *titleLabel;


@end

@implementation TRYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }

    
    [self setupCustomNavigationBar];
}

- (void)setShowNavigationBar:(BOOL)showNavigationBar
{
    _showNavigationBar = showNavigationBar;
    
    self.customNavigationBar.hidden = !showNavigationBar;
}


- (void)setupCustomNavigationBar
{
    [self customNavigationBar];
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    
    _titleLabel.text = titleStr;
}


- (UIView *)customNavigationBar
{
    if (_customNavigationBar == nil) {
        CGFloat leftButtonW = 60;
        CGFloat height = kStatusBarHeight + kNavBarHeight;
        UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YUScreenW, height)];
        [self.view addSubview:navigationBar];
        navigationBar.backgroundColor = TRYGlobalColor;
        _customNavigationBar = navigationBar;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [navigationBar addSubview:leftButton];
//        UIImage *image = [[UIImage imageNamed:@"back wihte"] imageWithColor:[UIColor blackColor]];
//        [leftButton setImage:image forState:UIControlStateNormal];
        leftButton.frame = CGRectMake(0, kStatusBarHeight, leftButtonW, kNavBarHeight);
        _leftButton = leftButton;
        leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [leftButton addTarget:self action:@selector(defaultLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(leftButtonW, kStatusBarHeight, YUScreenW - leftButtonW * 2, kNavBarHeight)];
        [navigationBar addSubview:centerView];
        // titleLabel
        UILabel *titleLabel = [[UILabel alloc] init];
        [centerView addSubview:titleLabel];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.frame = centerView.bounds;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [navigationBar addSubview:rightButton];
        rightButton.frame = CGRectMake(CGRectGetMaxX(centerView.frame), kStatusBarHeight, leftButtonW, kNavBarHeight);
        rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [rightButton addTarget:self action:@selector(defaultRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [rightButton setTitleColor:try_colorForHex(@"#262A32") forState:UIControlStateNormal];
        _rightButton = rightButton;
    }
    return _customNavigationBar;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGFloat textWidth = [_rightButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    
    if (textWidth > 55) {
        CGFloat width = textWidth + 25;
        _rightButton.frame = CGRectMake(YUScreenW - width, kStatusBarHeight, width, kNavBarHeight);
    }
    
}

- (void)defaultLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)defaultRightButtonClick {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
