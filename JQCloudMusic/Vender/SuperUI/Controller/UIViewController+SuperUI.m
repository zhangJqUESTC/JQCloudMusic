//
//  UIViewController+SuperUI.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/31.
//

#import "UIViewController+SuperUI.h"

@implementation UIViewController (SuperUI)
#pragma mark -启动界面相关
- (void)startController:(Class)data{
    UIViewController *controller = [[data alloc] init];
    [[self getNavigationController] pushViewController:controller animated:YES];
}

/// 获取导航控制器
-(UINavigationController *)getNavigationController{
    UINavigationController *nav =  self.navigationController;
    if (nav) {
        return nav;
    }
    
     UIViewController *rvc = [[UIApplication sharedApplication] keyWindow].rootViewController;
     if ([rvc isKindOfClass:[UINavigationController class]]) {
         nav = (UINavigationController *)rvc;
     } else {
         nav = [rvc navigationController];
     }
    
    return nav;
}

@end
