//
//  InputCodeController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/6.
//

//验证码输入框
#import <CRBoxInputView/CRBoxInputView.h>
//倒计时
#import <ZXCountDownView/ZXCountDownView.h>

#import "InputCodeController.h"
#import "CodeRequest.h"
#import "SetPasswordController.h"
#import "SetPasswordPageData.h"

@interface InputCodeController ()
@property(nonatomic, strong) UILabel *codeSendTargetView;
@property(nonatomic, strong) QMUIButton *sendView;

/// 验证码输入框
@property (nonatomic, strong) CRBoxInputView *codeInputView;

/// 倒计时
@property (nonatomic, strong) ZXCountDownCore *countDown;

/// 要发送什么类型验证码
@property (nonatomic, assign) int codeStyle;

@property (nonatomic, strong) CodeRequest *codeRequest;
@end

@implementation InputCodeController

- (void)initViews{
    [super initViews];
    [self setBackgroundColor:[UIColor colorLightWhite]];
    
    [self initLinearLayoutInputSafeArea];
    
    self.container.padding = UIEdgeInsetsMake(PADDING_LARGE2, PADDING_LARGE2, PADDING_LARGE2, PADDING_LARGE2);
    
    self.container.gravity = MyGravity_Horz_Right;
    
    //请输入验证码标题
    UILabel *inputTitleView = [UILabel new];
    inputTitleView.myWidth = MyLayoutSize.fill;
    inputTitleView.myHeight = MyLayoutSize.wrap;
    inputTitleView.text=R.string.localizable.verificationCode;
    inputTitleView.font = UIFontBoldMake(TEXT_LARGE4);
    inputTitleView.textColor = [UIColor colorOnSurface];
    [self.container addSubview:inputTitleView];
    
    //提示
    _codeSendTargetView = [UILabel new];
    _codeSendTargetView.myWidth = MyLayoutSize.fill;
    _codeSendTargetView.myHeight = MyLayoutSize.wrap;
    _codeSendTargetView.text=R.string.localizable.verificationCodeSentTo;
    _codeSendTargetView.font = UIFontMake(TEXT_MEDDLE);
    _codeSendTargetView.textColor = [UIColor colorOnSurface];
    [self.container addSubview:_codeSendTargetView];
    
    //验证码输入框
    self.codeInputView = [[CRBoxInputView alloc] initWithCodeLength:6];
    self.codeInputView.myTop = 30;
    self.codeInputView.myWidth = MyLayoutSize.fill;
    self.codeInputView.myHeight = 50;
    
    // 不设置时，默认UIKeyboardTypeNumberPad
    self.codeInputView.keyBoardType = UIKeyboardTypeNumberPad;
    
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    cellProperty.cellBorderColorSelected = [UIColor colorPrimary];
    self.codeInputView.customCellProperty = cellProperty;
    
    // BeginEdit:是否自动启用编辑模式
    [self.codeInputView loadAndPrepareViewWithBeginEdit:YES];
    [self.contentContainer  addSubview:self.codeInputView];

    // 输入类型（纯数字）
    _codeInputView.inputType = CRInputType_Number;

    // 获取值
    // 方法1, 当输入文字变化时触发回调block
    @weakify(self);
    _codeInputView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
        @strongify(self);
        NSLog(@"text:%@", text);
        if (isFinished) {
            [self processNext:text];
        }
    };
    [self.container addSubview:_codeInputView];
    
    //重新发送按钮
    _sendView = [ViewFactoryUtil linkButton];
    [_sendView setTitle:R.string.localizable.resend forState: UIControlStateNormal];
    [_sendView setTitleColor:[UIColor black80] forState:UIControlStateNormal];
    
    //点击事件
    [_sendView addTarget:self action:@selector(onSendClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_sendView sizeToFit];
    [self.container addSubview:_sendView];
}

- (void)initDatum{
    [super initDatum];

    //初始化倒计时
    _countDown = [[ZXCountDownCore alloc] init];
    _countDown.disableScheduleStore = YES;

    //显示验证码发送到目标
    _codeRequest = [CodeRequest new];
    NSString *target;
    if ([StringUtil isNotBlank:_pageData.phone]) {
        target=_pageData.phone;
        _codeStyle = VALUE10;
        _codeRequest.phone = target;
    } else {
        target=_pageData.email;
        _codeStyle = VALUE0;
        _codeRequest.email = target;
    }

    _codeSendTargetView.text = [R.string.localizable verificationCodeSentTo:target];

    [self sendCode];
}

-(void)onSendClick:(UIButton *)sender{
    [self sendCode];
}

- (void)sendCode{
    [[DefaultRepository shared] sendCode:_codeStyle data:_codeRequest success:^(BaseResponse * _Nonnull baseResponse, id  _Nonnull data) {
       //发送成功了

       //开始倒计时
       [self startCountDown];
   }];
}

/// 开始倒计时
/// 现在没有保存退出的状态
/// 也就说，返回在进来就可以点击了
-(void)startCountDown{
    @weakify(self);
    [_countDown setCountDown:60 mark:@"testCountDown" resBlock:^(long remainSec) {
        @strongify(self);
        if (remainSec == 0) {
            [self.sendView setTitle:R.string.localizable.resend forState: UIControlStateNormal];
            [self.sendView setEnabled:YES];
        }else{
            [self.sendView setTitle:[R.string.localizable resendCount:remainSec] forState: UIControlStateNormal];
        }
        [self.sendView sizeToFit];
    }];

    //开始倒计时
    [_countDown startCountDown];

    //禁用按钮
    [self.sendView setEnabled:NO];
}

-(void)processNext:(NSString *)data{
    if (_pageData.style == StylePhoneLogin) {
        //手机号验证码登录
        User *param = [User new];
        param.phone=_pageData.phone;
        param.email=_pageData.email;
        param.code=data;
        [self login:param];
    } else {
        //先校验验证码
        _codeRequest.code = data;
        [[DefaultRepository shared] checkCode:_codeRequest success:^(BaseResponse * _Nonnull baseResponse, id  _Nonnull d) {
            //重设密码
            SetPasswordPageData *pageData=[SetPasswordPageData new];
            pageData.phone = self.pageData.phone;
            pageData.email = self.pageData.email;
            pageData.code = data;
            [SetPasswordController start:self.navigationController data:pageData];
        } failure:^BOOL(BaseResponse * _Nullable baseResponse, NSError * _Nonnull error) {
            //清除验证码输入的内容
            [self.codeInputView clearAll];
            return NO;
        }];

    }
}

+ (void)start:(UINavigationController *)controller data:(InputCodePageData *)data{
    InputCodeController *newController=[[InputCodeController alloc] init];
    
    newController.pageData=data;
    
    [controller pushViewController:newController animated:YES];
}
@end
