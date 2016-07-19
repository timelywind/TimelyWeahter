//
//  YUNewsViewController.m
//  weibo
//
//  Created by qianfeng on 16/1/16.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#define YUNewfeatureCount  3

#import "YUNewsViewController.h"
#import "YUMainViewController.h"
#import "YUNavigationController.h"

@interface YUNewsViewController () <UIScrollViewDelegate>

@property (nonatomic,weak)UIScrollView *scrollView;

@property (nonatomic,weak)UIPageControl *pageControl;

@end

@implementation YUNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i<YUNewfeatureCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 如果是最后一个imageView，就往里面添加其他内容
        if (i == YUNewfeatureCount - 1)
        {
            [self setupLastImageView:imageView];
        }
        
    }
    // 3. 设置scrollView的其他属性
    scrollView.contentSize = CGSizeMake(YUNewfeatureCount * scrollW, 0);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // 4.添加pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = YUNewfeatureCount;
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = WColorRGB(253, 98, 42);
    pageControl.pageIndicatorTintColor = WColorRGB(189, 189, 189);
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH - 50;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    
    
}
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    

    UIButton *startBtn = [[UIButton alloc] init];
    startBtn.size = CGSizeMake(100, 40);
    startBtn.center = CGPointMake(YUScreenW * 0.5, YUScreenH * 0.8);
    startBtn.backgroundColor = [[UIColor colorWithWhite:0.800 alpha:1.000]colorWithAlphaComponent:0.3];
    [startBtn setTitle:@"开始体验" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
        
}

- (void)startClick
{
   [UIView animateWithDuration:1.5 animations:^{
       
       self.scrollView.alpha = 0.0;
       self.pageControl.alpha = 0.0;
       
   } completion:^(BOOL finished) {
       
       UIWindow *window = [UIApplication sharedApplication].keyWindow;
       YUMainViewController *mainVc = [[YUMainViewController alloc]init];
       YUNavigationController *nav = [[YUNavigationController alloc]initWithRootViewController:mainVc];
       window.rootViewController= nav;
   }];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    long page = (scrollView.contentOffset.x + scrollView.frame.size.width * 0.5)/scrollView.frame.size.width;
    
    self.pageControl.currentPage = page;
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
