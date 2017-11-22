//
//  UIViewController+AppearController.h
//  Lottery
//
//  Created by caiyi on 2017/11/22.
//  Copyright © 2017年 9188.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AppearController)

- (void)tt_controllerWillAppearForNavigation:(UIViewController*)willAppearController;
- (void)tt_controllerDidAppearForNavigation:(UIViewController*)didAppearController;

- (void)tt_controllerWillAppear;
- (void)tt_controllerDidAppear;
- (void)tt_controllerWillDisappear;
- (void)tt_controllerDidDisappear;

@end
