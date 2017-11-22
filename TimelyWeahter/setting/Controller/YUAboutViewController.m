//
//  YUAboutViewController.m
//  TimelyWeahter
//
//  Created by timely on 15/3/8.
//  Copyright © 2016年 timely. All rights reserved.
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
    
    myImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
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
