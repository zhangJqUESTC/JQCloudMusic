//
//  DiscoveryButtonView.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/17.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscoveryButtonView : MyLinearLayout
/// 图标控件
@property(nonatomic,strong) UIImageView *iconView;

/// 标题控件
@property(nonatomic,strong) UILabel *titleView;

/// 只有没有推荐按钮，才显示日期，其他按钮没有使用
@property(nonatomic,strong) UILabel *tipView;

- (void)showWithTitle:(NSString *)title icon:(UIImage *)icon;
@end

NS_ASSUME_NONNULL_END
