//
//  SplashController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/11.
//

#import "SplashController.h"
#include <MyLayout/MyLayout.h>
#import "SuperDateUtil.h"
#import "R.h"
#import "UIColor+Config.h"
#import "UIColor+Theme.h"
#import "TermServiceDialogController.h"
@interface SplashController ()
@property (nonatomic, strong) TermServiceDialogController *dialogController;
@end

@implementation SplashController

- (void) initViews{
    [super initViews];
    
    [self setBackgroundColor:[UIColor colorBackground]];
    [self initRelativeLayoutSafeArea];
    
    // banner
    UIImageView *bannerView = [UIImageView new];
    bannerView.myWidth = 75;
    bannerView.myHeight = 309;
    bannerView.myTop = 120;
    bannerView.myCenterX = 0;
    bannerView.image = [UIImage imageNamed:@"SplashBanner"];
    [self.container addSubview:bannerView];
    
    // 版权
    UILabel * agreementView = [UILabel new];
    agreementView.myWidth = MyLayoutSize.wrap;
    agreementView.myHeight = 15;
    agreementView.myBottom = 20;
    agreementView.myCenterX = 0;
    agreementView.font = [UIFont systemFontOfSize:12];
    agreementView.textColor = [UIColor black80];
    NSInteger year = [SuperDateUtil getCurrentYear];
    
    agreementView.text = [R.string.localizable copyright:year];
    [self.container addSubview:agreementView];
    
    // logo
    UIImageView * logoView = [UIImageView new];
    logoView.myWidth = 188;
    logoView.myHeight = 31;
    logoView.bottomPos.equalTo(agreementView.topPos).offset(16);
    logoView.myCenterX = 0;
    logoView.image = [UIImage imageNamed:@"SplashLogo"];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.container addSubview:logoView];
    
    NSLog(@"OK");
}

- (void)initDatum{
    [super initDatum];
    [self showTermsServiceAgreementDialog];

}

/// 显示同意服务条款对话框
- (void)showTermsServiceAgreementDialog{
    [self.dialogController show];
}

/// 主按钮点击
/// @param sender sender description
-(void)primaryClick:(UIButton *)sender{
    [self.dialogController hide];
}

/// 返回控制器，懒加载方式
- (TermServiceDialogController *)dialogController{
    if (!_dialogController) {
        _dialogController=[TermServiceDialogController new];
        _dialogController.titleView.text = R.string.localizable.termServicePrivacy;
        [_dialogController.primaryButton addTarget:self action:@selector(primaryClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dialogController;
}
@end
