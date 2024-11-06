//
//  LoginHomeController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/31.
//

#import "LoginHomeController.h"
#import "SuperWebController.h"
#import <YYText/YYText.h>
#import "LoginController.h"
#import "InputUserIdentityController.h"

@interface LoginHomeController ()
@property (nonatomic, strong) YYLabel *agreementView;
@end

@implementation LoginHomeController

- (void)initViews{
    [super initViews];
    [self setBackgroundColor:[UIColor colorLightWhite]];
    
    [self initRelativeLayoutSafeArea];

    //logo
    UIImageView *iconView=[[UIImageView alloc] initWithImage:R.image.logo];
    iconView.myWidth = 100;
    iconView.myHeight = 100;
    iconView.myCenterX = 0;
    iconView.myTop = 80;
    [self.container addSubview:iconView];
    
    //底部容器
    [self initBottomContainer];
    
    //用户协议
    
}

#pragma mark - 底部容器
-(void)initBottomContainer{
    MyLinearLayout *container = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
    container.myWidth = MyLayoutSize.fill;
    container.myHeight = MyLayoutSize.wrap;
    container.subviewSpace = PADDING_LARGE2;
    container.paddingLeading = PADDING_LARGE2;
    container.paddingRight = PADDING_LARGE2;
    container.myBottom = PADDING_LARGE2;
    [self.container addSubview:container];
    
    //手机号登录
    QMUIButton *phoneLoginButton = [ViewFactoryUtil primaryHalfFilletButton];
    [phoneLoginButton setTitle:R.string.localizable.phoneLogin forState:UIControlStateNormal];
    [phoneLoginButton addTarget:self action:@selector(onPhoneLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:phoneLoginButton];
    
    //用户名和密码登录
    QMUIButton *usernameLoginButton = [ViewFactoryUtil primaryHalfFilletOutlineButton];
    [usernameLoginButton setTitle:R.string.localizable.usernameLogin forState:UIControlStateNormal];
    [usernameLoginButton addTarget:self action:@selector(onUsernameClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:usernameLoginButton];
    
//    if (@available(iOS 13.0, *)){
//        //苹果登录
//        //文字不能修改，但可以稍微修改样式，具体查看官方文档
//        ASAuthorizationAppleIDButton *appleLoginView = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleWhite];
//        appleLoginView.myWidth = MyLayoutSize.fill;
//        appleLoginView.myHeight = BUTTON_MEDDLE;
//        [appleLoginView addTarget:self action:@selector(onAppleLoginClick:) forControlEvents:UIControlEventTouchUpInside];
//        [container addSubview:appleLoginView];
//    }
    
    //第三方登录容器
    MyLinearLayout *moreLogincontainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    moreLogincontainer.myTop = PADDING_LARGE;
    moreLogincontainer.myWidth = MyLayoutSize.fill;
    moreLogincontainer.myHeight = MyLayoutSize.wrap;
    
    //间距平分，首尾没有间距
    moreLogincontainer.gravity = MyGravity_Horz_Between;
    [container addSubview:moreLogincontainer];
    
    //微信登录
    QMUIButton *moreButtonView = [ViewFactoryUtil buttonWithImage:R.image.loginWechat selectedImage:R.image.loginWechatSelected];
    [moreButtonView addTarget:self action:@selector(onWechatClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreLogincontainer addSubview:moreButtonView];
    
    //qq登录
    moreButtonView = [ViewFactoryUtil buttonWithImage:R.image.loginQq selectedImage:R.image.loginQqSelected];
    [moreButtonView addTarget:self action:@selector(onQQClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreLogincontainer addSubview:moreButtonView];
    
    //微博登录
    moreButtonView = [ViewFactoryUtil buttonWithImage:R.image.loginWeibo selectedImage:R.image.loginWeiboSelected];
    [moreLogincontainer addSubview:moreButtonView];
    
    //邮箱登录
    moreButtonView = [ViewFactoryUtil buttonWithImage:R.image.loginNetease selectedImage:R.image.loginNeteaseSelected];
    [moreLogincontainer addSubview:moreButtonView];
    
    //用户协议
    //这样实现的不好国际化
    NSMutableAttributedString *agreementString=[[NSMutableAttributedString alloc] initWithString:R.string.localizable.userAgreement];
    //设置字体
    agreementString.yy_font = [UIFont systemFontOfSize:TEXT_SMALL];

    //设置文本颜色
    agreementString.yy_color = [UIColor black80];

    NSRange range = NSMakeRange(9, 4);
    [agreementString yy_setTextHighlightRange:range color:[UIColor link] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //用户协议点击
        [SuperWebController start:self.navigationController title:R.string.localizable.userService uri:URI_SERVICE];
    }];

    range = NSMakeRange(16, 4);;
    [agreementString yy_setTextHighlightRange:range color:[UIColor link] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //隐私政策
        [SuperWebController start:self.navigationController title:nil uri:URI_PRIVACY];
    }];

    _agreementView = [[YYLabel alloc] init];
    _agreementView.attributedText = agreementString;
    _agreementView.myWidth = MyLayoutSize.fill;
    _agreementView.myHeight = MyLayoutSize.wrap;
    _agreementView.textAlignment = NSTextAlignmentCenter;
    _agreementView.numberOfLines = 0;
    _agreementView.userInteractionEnabled = YES;
    [container addSubview:_agreementView];
}

//手机号登录
- (void)onPhoneLoginClick:(QMUIButton *)sender{
    [InputUserIdentityController startWithPhoneLogin:self.navigationController];
}

//用户名和密码登录
- (void)onUsernameClick:(QMUIButton *)sender{
    [self startController:[LoginController class]];
}

//微信登录
- (void)onWechatClick:(QMUIButton *)sender{
    
}

//qq登录
- (void)onQQClick:(QMUIButton *)sender{
    
}


@end
