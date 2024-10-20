//
//  PlaceholderView.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/16.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaceholderView : MyRelativeLayout
/// 图标控件
@property(nonatomic,strong) UIImageView *iconView;

/// 标题控件
@property(nonatomic,strong) UILabel *titleView;

/// 显示数据
/// @param title title description
/// @param icon icon description
-(void)showWithTitle:(NSString *)title icon:(UIImage *)icon;
@end

NS_ASSUME_NONNULL_END
