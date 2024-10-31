//
//  SuperSettingView.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/30.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

///view点击block
typedef void(^ViewClick)(UIView *view);

///开关状态改变了block
typedef void(^SwitchChanged)(UISwitch *view);

@interface SuperSettingView : MyLinearLayout
/// 图标
@property(nonatomic, strong) UIImageView *iconView;

/// 标题
@property(nonatomic, strong) UILabel *titleView;

/// 单行输入
@property (nonatomic, strong) QMUITextField *textFieldView;

/// 更多文本
@property(nonatomic, strong) UILabel *moreView;

/// 开关
@property(nonatomic, strong) UISwitch *superSwitch;

/// 更多图标
@property(nonatomic, strong) UIImageView *moreIconView;

/// 点击回调
@property(nonatomic, strong) ViewClick click;

/// 开关状态改变了
@property(nonatomic, strong) SwitchChanged switchChanged;

#pragma mark - 创建方法

/// 创建有图标，标题，详情文本，更多图标item
/// @param icon <#icon description#>
/// @param title <#title description#>
+(instancetype)smallWithIcon:(UIImage *)icon title:(NSString *)title click:(ViewClick)click;

/// 创建有图标，标题，详情文本，更多图标item，有开关
/// @param icon <#icon description#>
/// @param title <#title description#>
/// @param click <#click description#>
+(instancetype)smallWithIcon:(UIImage *)icon title:(NSString *)title switchChanged:(SwitchChanged)switchChanged  click:(ViewClick)click;

+(instancetype)withTitle:(NSString *)title switchChanged:(SwitchChanged)switchChanged;

+ (instancetype)withIcon:(UIImage *)icon title:(NSString *)title click:(ViewClick)click;

/// 文本输入
/// @param title <#title description#>
/// @param placeholder <#placeholder description#>
+ (instancetype)withInput:(NSString *)title placeholder:(NSString *)placeholder;

/// 创建标题，详情文本item
/// @param title <#title description#>
+(instancetype)smallWith:(NSString *)title click:(ViewClick)click;

+(instancetype)smallWith:(NSString *)title;

/// 图标，标题，开关效果（图片实现的）
/// @param icon <#icon description#>
/// @param title <#title description#>
/// @param click <#click description#>
+ (instancetype)radioWithIcon:(UIImage *)icon title:(NSString *)title click:(ViewClick)click;
@end

NS_ASSUME_NONNULL_END
