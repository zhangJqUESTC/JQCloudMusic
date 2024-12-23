//
//  SuperSettingView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/30.
//

#import "SuperSettingView.h"

@implementation SuperSettingView

- (instancetype)init{
    self=[super initWithOrientation:MyOrientation_Horz];
    [self initViews];
    [self initListeners];
    
    return self;
}


-(void)initViews{
    self.myWidth = MyLayoutSize.fill;
    self.myHeight = 55;
    self.padding = UIEdgeInsetsMake(0, PADDING_OUTER, 0, PADDING_OUTER);
    self.gravity = MyGravity_Vert_Center;
    self.subviewSpace = PADDING_MEDDLE;
    self.backgroundColor = [UIColor colorSurface];
    
    [self addSubview:self.iconView];
    [self addSubview:self.titleView];
    [self addSubview:self.textFieldView];
    [self addSubview:self.moreView];
    [self addSubview:self.moreIconView];
}

-(void)initSwitch{
    [self insertSubview:self.superSwitch atIndex:3];
}

/// 小容器样式
-(void)small{
    self.padding = UIEdgeInsetsMake(0, PADDING_OUTER, 0, PADDING_OUTER);
    self.myHeight=50;
}

-(void)initListeners{
    self.userInteractionEnabled = YES;
    
    //点击
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapClick:)];
//    tapGestureRecognizer.delegate=self;
    [self addGestureRecognizer:tapGestureRecognizer];
}

-(void)onTapClick:(UITapGestureRecognizer *)gestureRecognizer{
    if (self.click) {
        self.click(gestureRecognizer.qmui_targetView);
    }
}

#pragma mark - 创建方法
+ (instancetype)smallWithIcon:(UIImage *)icon title:(NSString *)title click:(ViewClick)click{
    SuperSettingView *result = [SuperSettingView new];
    
    //小容器
    [result small];
    
    //设置数据
    result.iconView.image = [icon withTintColor];
    result.titleView.text = title;
    
    result.click = click;
    
    return result;
}

+(instancetype)smallWithIcon:(UIImage *)icon title:(NSString *)title switchChanged:(SwitchChanged)switchChanged  click:(ViewClick)click{
    SuperSettingView *result = [self smallWithIcon:icon title:title click:click];
    
    result.switchChanged=switchChanged;
    
    [result initSwitch];
    
    return result;
}

+(instancetype)withTitle:(NSString *)title switchChanged:(SwitchChanged)switchChanged{
    SuperSettingView *result = [SuperSettingView new];
    
    [result.iconView hide];
    [result.moreIconView hide];
    
    //设置数据
    result.titleView.text = title;
    
    result.switchChanged=switchChanged;
    
    [result initSwitch];
    
    return result;
}

- (void)switchChanged:(UISwitch *) sender {
    self.switchChanged(sender);
}

+ (instancetype)withIcon:(UIImage *)icon title:(NSString *)title click:(ViewClick)click{
    SuperSettingView *result = [SuperSettingView new];
    
    //设置数据
    result.iconView.image = [icon withTintColor];
    result.titleView.text = title;
    
    result.click = click;
    
    return result;
}

/// 文本输入
/// @param title title description
/// @param placeholder placeholder description
+ (instancetype)withInput:(NSString *)title placeholder:(NSString *)placeholder{
    SuperSettingView *result = [SuperSettingView new];
    
    result.padding=UIEdgeInsetsMake(PADDING_MEDDLE, PADDING_LARGE, PADDING_MEDDLE, PADDING_LARGE);
    result.titleView.weight=0;
    
    [result.iconView hide];
    [result.textFieldView show];
    [result.moreIconView hide];
    
    //设置数据
    result.titleView.text = title;
    result.textFieldView.placeholder = placeholder;
    
    return result;
}

+(instancetype)smallWith:(NSString *)title click:(ViewClick)click{
    SuperSettingView *result = [SuperSettingView new];
    
    result.myHeight = MyLayoutSize.wrap;
    result.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [result.iconView hide];
    [result.moreIconView hide];
    
    result.titleView.font=[UIFont systemFontOfSize:TEXT_MEDDLE];
    
    //设置数据
    result.titleView.text = title;
    
    result.click = click;
    
    return result;
}

+(instancetype)smallWith:(NSString *)title{
    return [self smallWith:title click:nil];
}

/// 图标，标题，开关效果（图片实现的）
/// @param icon icon description
/// @param title title description
/// @param click click description
+ (instancetype)radioWithIcon:(UIImage *)icon title:(NSString *)title click:(ViewClick)click{
    SuperSettingView *result = [SuperSettingView new];
    result.padding=UIEdgeInsetsMake(PADDING_MEDDLE, PADDING_LARGE, PADDING_MEDDLE, PADDING_LARGE);
    
    result.iconView.myWidth = 30;
    result.iconView.myHeight = 30;
    
    result.moreIconView.myWidth = 20;
    result.moreIconView.myHeight = 20;
    [result.moreIconView show];
    
    //设置数据
    result.iconView.image = icon;
    result.titleView.text = title;
    
    result.moreIconView.image = R.image.check;
    
    result.click = click;
    
    return result;
}

#pragma mark - 创建控件

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.myWidth = 20;
        _iconView.myHeight = 20;
        _iconView.tintColor = [UIColor colorOnBackground];
        _iconView.myCenterY = 0;
    }
    return _iconView;
}

- (UILabel *)titleView{
    if (!_titleView) {
        _titleView = [UILabel new];
        
        //因为设置了父容器为MyGravity_Horz_Stretch，所以子view如果不设置宽度
        //就会填充沾满剩余宽度
        _titleView.myWidth = MyLayoutSize.wrap;
        _titleView.myHeight = MyLayoutSize.wrap;
        _titleView.text = @"这是标题";
        _titleView.font = [UIFont systemFontOfSize:TEXT_LARGE];
        _titleView.textColor = [UIColor colorOnBackground];
        _titleView.weight=1;
    }
    return _titleView;
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
        
        [_textFieldView hide];
    }
    return _textFieldView;
}

- (UILabel *)moreView{
    if (!_moreView) {
        _moreView = [UILabel new];
        _moreView.myWidth = MyLayoutSize.wrap;
        _moreView.myHeight = MyLayoutSize.wrap;
        _moreView.font = [UIFont systemFontOfSize:TEXT_SMALL];
        _moreView.textColor = [UIColor lightGray];
        _moreView.myCenterY = 0;
        _moreView.rightPos.equalTo(self.moreIconView.leftPos).offset(5);
    }
    return _moreView;
}

- (UIImageView *)moreIconView{
    if (!_moreIconView) {
        _moreIconView = [ViewFactoryUtil moreIconView];
        _moreIconView.myCenterY = 0;
        _moreIconView.myRight=0;
    }
    return _moreIconView;
}

- (UISwitch *)superSwitch{
    if (!_superSwitch) {
        _superSwitch = [UISwitch new];
        _superSwitch.myWidth = MyLayoutSize.wrap;
        _superSwitch.myHeight = MyLayoutSize.wrap;
        
        //开关状态为开的时候左侧颜色
        _superSwitch.onTintColor = [UIColor colorPrimary];
        
        [_superSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        _superSwitch.myCenterY = 0;
        _superSwitch.rightPos.equalTo(self.moreIconView.leftPos).offset(5);
    }
    return _superSwitch;
}


@end
