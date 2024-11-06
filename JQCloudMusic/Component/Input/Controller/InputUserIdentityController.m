//
//  InputUserIdentityController.m
//  JQCloudMusic
//  输入用户邮箱，手机号通用界面
//  主要用到手机号登录，找回密码时，输入手机号，输入邮箱
//  根据启动参数区分是那种功能
//  之所以设计为当前界面只是输入，下一个界面才发送验证码，原因是限制发送验证了
//  又更改了输入框的手机号，邮箱w
//  Created by zhangjq on 2024/11/6.
//

#import "InputUserIdentityController.h"
#import "SuperInputView.h"
#import "InputCodePageData.h"
#import "InputCodeController.h"


@interface InputUserIdentityController ()
/// 用户名输入框
@property(nonatomic, strong) SuperInputView *usernameView;

@property(nonatomic, strong) QMUIButton *primaryButton;
@end

@implementation InputUserIdentityController

- (void)initViews{
    [super initViews];
    [self setBackgroundColor:[UIColor colorLightWhite]];
    
    [self initLinearLayoutInputSafeArea];
  
    //用户名输入框
    _usernameView = [SuperInputView withPlaceholder:R.string.localizable.enterPhone];
    
    //监听文本输入事件
    [_usernameView.textFieldView addTarget:self action:@selector(onTextChanged:) forControlEvents:
     UIControlEventEditingChanged];
    [self.container addSubview:_usernameView];
    
    //按钮
    _primaryButton = [ViewFactoryUtil primaryHalfFilletButton];
    [_primaryButton setTitle:R.string.localizable.sendCode forState:UIControlStateNormal];
    [_primaryButton addTarget:self action:@selector(onPrimaryClick:) forControlEvents:UIControlEventTouchUpInside];
    [_primaryButton setEnabled:NO];
    [self.container addSubview:_primaryButton];
}

- (void)initDatum{
    [super initDatum];
    
    switch (_style) {
        case StylePhoneLogin:
            //手机号登录
            self.title = R.string.localizable.phoneLogin;
            
            //输入手机号
            _usernameView.textFieldView.placeholder = R.string.localizable.enterPhone;
            break;
            
        default:
            //找回密码
            self.title = R.string.localizable.forgotPassword;
            
            //输入手机号
            _usernameView.textFieldView.placeholder = R.string.localizable.enterPhoneOrEmail;
            break;
    }
    
}

+ (void)startWithPhoneLogin:(UINavigationController *)controller{
    [self start:controller style:StylePhoneLogin];
}

/// 找回密码
/// @param controller controller description
+ (void)startWithForgotPassword:(UINavigationController *)controller{
    [self start:controller style:StyleForgotPassword];
}

/// 启动界面
/// @param controller controller description
/// @param style style description
+ (void)start:(UINavigationController *)controller style:(ListStyle)style{
    InputUserIdentityController *newController=[[InputUserIdentityController alloc] init];
    
    newController.style=style;
    
    [controller pushViewController:newController animated:YES];
}
#pragma mark - 事件

/// 主按钮点击
/// @param sender sender description
- (void)onPrimaryClick:(QMUIButton *)sender{
    NSString *content = [_usernameView.textFieldView.text trim];
    BOOL isPhone = [SuperRegularUtil isPhone:content];
    if (isPhone || [SuperRegularUtil isEmail:content]) {
        
        InputCodePageData *pageData = [InputCodePageData new];
        pageData.style=_style;
        if (isPhone) {
            pageData.phone=content;
        } else {
            pageData.email=content;
        }

        [InputCodeController start:self.navigationController data:pageData];
    } else {
        [SuperToast showWithTitle:R.string.localizable.enterPhoneOrEmail];
    }
}

/// 文本输入框内容改变了
/// @param sender sender description
- (void)onTextChanged:(QMUITextField *)sender{
    [_primaryButton setEnabled:[StringUtil isNotBlank:[sender.text trim]]];
}



@end
