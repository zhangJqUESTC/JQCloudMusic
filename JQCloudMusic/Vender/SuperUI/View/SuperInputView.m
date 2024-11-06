//
//  SuperInputView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/31.
//

#import "SuperInputView.h"

@implementation SuperInputView

- (void)initViews{
    [super initViews];
    
    self.myWidth = MyLayoutSize.fill;
    self.myHeight = MyLayoutSize.wrap;
}

-(void)initInput{
    //内容容器
    _container = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    _container.myWidth = MyLayoutSize.fill;
    _container.myHeight = MyLayoutSize.wrap;
    _container.subviewSpace=PADDING_SMALL;
    _container.gravity = MyGravity_Vert_Center;
    [self addSubview:_container];
    
    [_container addSubview:self.iconView];
//    [_container addSubview:self.titleView];
    [_container addSubview:self.textFieldView];
}

-(void)smallRadius{
    //小圆角，边框
    self.layer.cornerRadius = SMALL_RADIUS;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorDivider] CGColor];
    
    //两端有padding
    _container.paddingLeading = PADDING_MEDDLE;
    _container.paddingTrailing = PADDING_MEDDLE;
}

/// 底部显示边框
-(void)borderBottom{
    self.qmui_borderColor = [UIColor black90];
    self.qmui_borderPosition = QMUIViewBorderPositionBottom;
}

-(void)passwordStyle{
    _textFieldView.secureTextEntry = YES;
}

-(void)initMultiInput:(NSInteger)maxCount{
    self.maxCount=maxCount;
    
    //内容容器
    _container = [MyRelativeLayout new];
    _container.myWidth = MyLayoutSize.fill;
    _container.myHeight = MyLayoutSize.wrap;
    [self addSubview:_container];
    
    [_container addSubview:self.textView];
    
    if ([self isCount]) {
        [_container addSubview:self.countView];
        self.countView.text=[NSString stringWithFormat:@"%ld/%ld",0L,_maxCount];
    }
}

-(BOOL)isCount{
    return _maxCount!=-1;
}


#pragma mark - 快捷创建方法
+(SuperInputView *)withImage:(UIImage *)image placeholder:(NSString *)placeholder{
    SuperInputView *result = [SuperInputView new];
    
    [result initInput];
    
    //图标
    result.iconView.image = image;
    result.iconView.visibility = MyVisibility_Visible;
    
    //输入框
    result.textFieldView.placeholder = placeholder;
    
    return result;
}

+(SuperInputView *)withPlaceholder:(NSString *)placeholder{
    SuperInputView *result = [SuperInputView new];
    
    [result initInput];
    
    //输入框
    result.textFieldView.placeholder = placeholder;
    
    [result borderBottom];
    
    return result;
}

+(SuperInputView *)withMultiInput:(NSString *)placeholder maxCount:(NSInteger)maxCount{
    SuperInputView *result = [SuperInputView new];
    
    [result initMultiInput:maxCount];
    
    //输入框
    result.textView.placeholder = placeholder;
    
    [result borderBottom];
    
    return result;
}

/// 小圆角输入框
/// @param placeholder <#placeholder description#>
+(SuperInputView *)withSmallRadiusPlaceholder:(NSString *)placeholder{
    SuperInputView *result = [SuperInputView new];
    
    [result initInput];
    
    //输入框
    result.textFieldView.placeholder = placeholder;
    
    result.backgroundColor=[UIColor colorDivider];
    [result smallRadius];
    
    return result;
}


#pragma mark - 创建控件

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.myWidth = 20;
        _iconView.myHeight=20;
        _iconView.tintColor = [UIColor black66];
        _iconView.image = [R.image.inputUsername withTintColor];
        _iconView.visibility = MyVisibility_Gone;
    }
    return _iconView;
}

- (QMUITextField *)textFieldView{
    if (!_textFieldView) {
        _textFieldView = [QMUITextField new];
        _textFieldView.myWidth = MyLayoutSize.wrap;
        _textFieldView.myHeight = INPUT_MEDDLE;
        _textFieldView.weight=1;
        _textFieldView.placeholder = @"请输入用户名";
        _textFieldView.font = [UIFont systemFontOfSize:TEXT_LARGE2];
        _textFieldView.textColor = [UIColor colorOnSurface];
        
        //编辑的时候显示清除按钮
        _textFieldView.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        //关闭首字母大写
        _textFieldView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _textFieldView;
}

- (QMUITextView *)textView{
    if (!_textView) {
        _textView = [QMUITextView new];
        _textView.myWidth = MyLayoutSize.fill;
        _textView.myHeight = 150;
        _textView.placeholder = @"测试";
        _textView.font = [UIFont systemFontOfSize:TEXT_LARGE2];
        _textView.textColor = [UIColor colorOnSurface];
        _textView.placeholderColor = [UIColor black80];
        _textView.delegate=self;
        
        //关闭首字母大写
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _textView;
}

- (UILabel *)countView{
    if (!_countView) {
        _countView = [UILabel new];
        _countView.myWidth = MyLayoutSize.wrap;
        _countView.myHeight = MyLayoutSize.wrap;
        _countView.myRight=PADDING_MEDDLE;
        _countView.myBottom=PADDING_MEDDLE;
        _countView.text = @"0/140";
        _countView.font = [UIFont systemFontOfSize:TEXT_SMALL];
        _countView.textColor = [UIColor black80];
    }
    return _countView;
}

#pragma mark - 多行输入框代理

/// 输入文本回调
/// @param textView <#textView description#>
/// @param range <#range description#>
/// @param text <#text description#>
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([self isCount]){
        NSInteger count = textView.text.length;
        if (count>=_maxCount && [StringUtil isNotBlank:text]) {
            //超出长度了
            //并且输入的内容不是删除按钮

            //不为空是过滤掉删除键
            //因为当按删除键时
            //内容就是空
            return NO;
        }
    }
    
    return YES;
}

/// 输入文本回调
/// @param textView <#textView description#>
- (void)textViewDidChange:(UITextView *)textView{
    if (![self isCount]) {
        return;
    }
    NSInteger count=textView.text.length;
    _countView.text=[NSString stringWithFormat:@"%ld/%ld",(long)count,_maxCount];
}

@end
