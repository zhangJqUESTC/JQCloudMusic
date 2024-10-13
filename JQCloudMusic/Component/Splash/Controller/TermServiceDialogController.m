//
//  TermServiceDialogController.m
//  JQCloudMusic
//  服务条款和隐私协议对话框
//  Created by zhangjq on 2024/10/12.
//

#import "TermServiceDialogController.h"
@interface TermServiceDialogController () <QMUIModalPresentationContentViewControllerProtocol>

@end

@implementation TermServiceDialogController
-(void)initViews{
    [super initViews];
    self.view.backgroundColor = [UIColor colorDivider];
    self.view.myWidth = MyLayoutSize.fill;
    self.view.myHeight = MyLayoutSize.wrap;
    
    //根容器
    self.rootContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
    self.rootContainer.subviewSpace=0.5;
    self.rootContainer.myWidth=MyLayoutSize.fill;
    self.rootContainer.myHeight=MyLayoutSize.wrap;
    [self.view addSubview:self.rootContainer];
    
    //内容容器
    self.contentContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
    self.contentContainer.subviewSpace=25;
    self.contentContainer.myWidth=MyLayoutSize.fill;
    self.contentContainer.myHeight=MyLayoutSize.wrap;
    self.contentContainer.backgroundColor = [UIColor colorBackground];
    self.contentContainer.padding=UIEdgeInsetsMake(30, 16, 30, 16);
    self.contentContainer.gravity=MyGravity_Horz_Center;
    [self.rootContainer addSubview:self.contentContainer];
    
    //标题
    [self.contentContainer addSubview:self.titleView];
    
    self.textView=[UITextView new];
    self.textView.myWidth=MyLayoutSize.fill;
    
    //超出的内容，自动支持滚动
    self.textView.myHeight=230;
    self.textView.text=@"在继续享受我们的服务之前，请务必阅读并同意以下协议。我们致力于保护你的个人隐私，并确保你在使用 JQ云音乐时获得最佳的体验。1.用户协议：本协议详细说明了你在使用 JQ云音乐时的权利和义务。通过该协议，你将了解如何合法、合规地使用我们的平台服务，包括(1)如何管理你的音乐库和播放列表; (2)社区互动的行为规范; (3)版权声明和知识产权保护; (4)违反协议时的处理措施; 2.隐私政策. 我们非常重视你的隐私和数据安全。隐私政策将向你解释. (1)我们收集哪些类型的个人数据（如账户信息、设备信息、使用行为等）; (2)我们如何使用这些数据来提供个性化的服务; (3) 我们如何确保这些数据的安全性，并遵守相关的法律法规. 我们承诺不会将你的个人数据透露给任何未经授权的第三方，并会采取严格的措施来保障数据的安全; 3.数据共享声明: 为提升你的使用体验，我们可能会与部分合作伙伴共享某些必要的信息，例如分析平台数据以改进功能。请放心，这些操作都在法律允许的范围内进行，且仅限于提升你的使用体验。你的选择:(1)查看完整的用户协议; (2)查看完整的隐私政策. 请注意: 继续使用JQ云音乐即表示你同意我们的用户协议和隐私政策. 如果你不同意这些条款，遗憾的是你将无法继续使用我们的服务. 你可以选择：[同意并继续使用]通过点击“同意”，你确认已阅读并同意上述内容。你可以随时在应用内的设置中查看或更新这些协议。[拒绝并退出]如果你拒绝协议，将退出 JQ云音乐。你随时可以返回并重新阅读和接受我们的条款。特别提示：如果你需要了解更多关于我们如何保护你个人隐私的信息，或者对用户协议的某些条款有疑问，请随时通过帮助中心或联系客服获取支持。感谢你对JQ云音乐的信任与支持！期待为你带来更好的音乐体验";
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.editable =NO;
    
    [self.contentContainer addSubview:self.textView];
    [self.contentContainer addSubview:self.primaryButton];
    //不同意按钮按钮
    self.disagreeButton = [ViewFactoryUtil linkButton];
    [self.disagreeButton setTitle:R.string.localizable.disagree forState: UIControlStateNormal];
    [self.disagreeButton setTitleColor:[UIColor black80] forState:UIControlStateNormal];
    [self.disagreeButton addTarget:self action:@selector(disagreeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.disagreeButton sizeToFit];
    [self.contentContainer addSubview:self.disagreeButton];
    
}

- (void)show{
    self.modalController = [QMUIModalPresentationViewController new];
    self.modalController.animationStyle = QMUIModalPresentationAnimationStyleFade;
    
    //点击外部不隐藏
    [self.modalController setModal:YES];
    
    //边距
    self.modalController.contentViewMargins=UIEdgeInsetsMake(PADDING_LARGE2, PADDING_LARGE2, PADDING_LARGE2, PADDING_LARGE2);
    
    //设置要显示的内容控件
    self.modalController.contentViewController=self;
    
    [self.modalController showWithAnimated:YES completion:nil];
}

- (void)hide{
    [self.modalController hideWithAnimated:YES completion:nil];
}

#pragma mark - 事件
-(void)disagreeClick:(UIButton *)sender{
    [self hide];
    
    //退出应用
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    UIWindow *window = app.window;
//
//    [UIView animateWithDuration:0.5f animations:^{
//        window.alpha = 0;
//        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
//    } completion:^(BOOL finished) {
//        exit(0);
//    }];
    
    exit(0);
}

#pragma mark - 创建控件
- (UILabel *)titleView{
    if (!_titleView) {
        _titleView=[UILabel new];
        _titleView.myWidth=MyLayoutSize.fill;
        _titleView.myHeight=MyLayoutSize.wrap;
        _titleView.text=@"用户协议与隐私政策";
        _titleView.textAlignment=NSTextAlignmentCenter;
        _titleView.font=[UIFont boldSystemFontOfSize:20];
        _titleView.textColor=[UIColor colorOnSurface];
    }
    return _titleView;
}

- (QMUIButton *)primaryButton{
    if (!_primaryButton) {
        _primaryButton = [ViewFactoryUtil primaryHalfFilletButton];
        [_primaryButton setTitle:R.string.localizable.agree forState:UIControlStateNormal];
    }
    return _primaryButton;
}

@end
