//
//  SetPasswordController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/6.
//

#import "SetPasswordController.h"
#import "SuperInputView.h"

@interface SetPasswordController ()
@property(nonatomic, strong) SuperInputView *passwordView;
@property(nonatomic, strong) SuperInputView *confirmPasswordView;

@property(nonatomic, strong) QMUIButton *primaryButton;
@end

@implementation SetPasswordController

- (void)initViews{
    [super initViews];
    [self setBackgroundColor:[UIColor colorLightWhite]];

    self.title = R.string.localizable.setPassword;

    [self initLinearLayoutInputSafeArea];

    //密码输入框
    _passwordView = [SuperInputView withPlaceholder:R.string.localizable.enterPassword];
    [_passwordView passwordStyle];
    [self.container addSubview:_passwordView];

    //确认密码输入框
    _confirmPasswordView = [SuperInputView withPlaceholder:R.string.localizable.enterConfirmPassword];
    [_confirmPasswordView passwordStyle];
    [self.container addSubview:_confirmPasswordView];

    //按钮
    _primaryButton = [ViewFactoryUtil primaryHalfFilletButton];
    [_primaryButton setTitle:R.string.localizable.confirm forState:UIControlStateNormal];
    [_primaryButton addTarget:self action:@selector(onPrimaryClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:_primaryButton];
}

#pragma mark - 事件

/// 主按钮点击
/// @param sender sender description
- (void)onPrimaryClick:(QMUIButton *)sender{
    //密码
    NSString *password = [_passwordView.textFieldView.text trim];
    if ([StringUtil isBlank:password]) {
        [SuperToast showWithTitle:R.string.localizable.enterPassword];
        return;
    }

    //判断密码格式
    if (![StringUtil isPassword:password]) {
        [SuperToast showWithTitle:R.string.localizable.errorPasswordFormat];
        return;
    }

    //确认密码
    NSString *confirmPassword = [_passwordView.textFieldView.text trim];
    if ([StringUtil isBlank:confirmPassword]) {
        [SuperToast showWithTitle:R.string.localizable.enterConfirmPassword];
        return;
    }

    if (![StringUtil isPassword:confirmPassword]) {
        [SuperToast showWithTitle:R.string.localizable.errorConfirmPasswordFormat];
        return;
    }

    //判断密码和确认密码是否一样
    if (![password isEqualToString:confirmPassword]) {
        [SuperToast showWithTitle:R.string.localizable.errorConfirmPassword];
        return;
    }

    User *param = [User new];
    param.phone = _pageData.phone;
    param.email = _pageData.email;
    param.code = _pageData.code;
    param.password = password;

    [[DefaultRepository shared] resetPassword:param success:^(BaseResponse * _Nonnull baseResponse, id  _Nonnull data) {
        [self login:param];
    }];
}
#pragma mark - 启动界面

+ (void)start:(UINavigationController *)controller data:(SetPasswordPageData *)data{
    SetPasswordController *newController=[[SetPasswordController alloc] init];

    newController.pageData=data;

    [controller pushViewController:newController animated:YES];
}

@end
