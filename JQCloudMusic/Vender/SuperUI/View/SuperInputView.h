//
//  SuperInputView.h
//  JQCloudMusic
//  输入控件
//  Created by zhangjq on 2024/10/31.
//

#import "BaseRelativeLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuperInputView : BaseRelativeLayout
/// 内容容器，就是放图标，标题等
@property (nonatomic, strong) MyBaseLayout *container;

/// 图标控件
 @property (nonatomic, strong) UIImageView *iconView;

/// 单行输入
@property (nonatomic, strong) QMUITextField *textFieldView;

/// 多行输入
@property (nonatomic, strong) QMUITextView *textView;

/// 显示字数
@property (nonatomic, strong) UILabel *countView;

@property(nonatomic, assign) NSInteger maxCount;

/// 小圆角，灰色边框
-(void)smallRadius;

/// 密码样式
-(void)passwordStyle;

#pragma mark - 快捷创建方法
+(SuperInputView *)withImage:(UIImage *)image placeholder:(NSString *)placeholder;

+(SuperInputView *)withPlaceholder:(NSString *)placehoslder;

/// 多行输入
/// @param placeholder <#placeholder description#>
/// @param maxCount -1，不限制输入长度
+(SuperInputView *)withMultiInput:(NSString *)placeholder maxCount:(NSInteger)maxCount;


/// 小圆角输入框
/// @param placeholder <#placeholder description#>
+(SuperInputView *)withSmallRadiusPlaceholder:(NSString *)placeholder;
@end

NS_ASSUME_NONNULL_END
