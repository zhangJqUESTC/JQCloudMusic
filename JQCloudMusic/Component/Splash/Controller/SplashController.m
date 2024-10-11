//
//  SplashController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/11.
//

#import "SplashController.h"
#include <MyLayout/MyLayout.h>
#import "SuperDateUtil.h"
@interface SplashController ()

@end

@implementation SplashController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 根容器
    MyRelativeLayout *container = [MyRelativeLayout new];
    
    //从安全区开始
    container.leadingPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    container.trailingPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    container.topPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    container.bottomPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    
    [self.view addSubview:container];
    
    // banner
    UIImageView *bannerView = [UIImageView new];
    bannerView.myWidth = 75;
    bannerView.myHeight = 309;
    bannerView.myTop = 120;
    bannerView.myCenterX = 0;
    bannerView.image = [UIImage imageNamed:@"SplashBanner"];
    [container addSubview:bannerView];
    
    // 版权
    UILabel * agreementView = [UILabel new];
    agreementView.myWidth = MyLayoutSize.wrap;
    agreementView.myHeight = 15;
    agreementView.myBottom = 20;
    agreementView.myCenterX = 0;
    agreementView.font = [UIFont systemFontOfSize:12];
    agreementView.textColor = [UIColor grayColor];
    NSInteger year = [SuperDateUtil getCurrentYear];
    agreementView.text = [NSString stringWithFormat:@"CopyRight @%ld JQCloudMusic. All Right Reserve",year];
    [container addSubview:agreementView];
    
    // logo
    UIImageView * logoView = [UIImageView new];
    logoView.myWidth = 188;
    logoView.myHeight = 21;
    logoView.bottomPos.equalTo(agreementView.topPos).offset(16);
    logoView.myCenterX = 0;
    logoView.image = [UIImage imageNamed:@"SplashLogo"];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    [container addSubview:logoView];
    
    
    NSLog(@"OK");
    
}

@end
