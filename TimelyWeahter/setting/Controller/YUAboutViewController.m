//
//  YUAboutViewController.m
//  TimelyWeahter
//
//  Created by qianfeng on 16/3/8.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "YUAboutViewController.h"

@interface YUAboutViewController ()

@end

@implementation YUAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *myImageView = [[UIImageView alloc]init];
    myImageView.image = [UIImage imageNamed:@"weather"];
    [self.view addSubview:myImageView];
    
    myImageView.frame = CGRectMake(0, 0, YUScreenW, YUScreenH);
    
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
