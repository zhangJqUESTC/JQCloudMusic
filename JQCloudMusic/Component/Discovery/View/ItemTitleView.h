//
//  ItemTitleView.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/17.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemTitleView : MyRelativeLayout
/// 标题控件
@property(nonatomic,strong) UILabel *titleView;

/// 更多图标
@property(nonatomic,strong) UIImageView *moreIconView;
@end

NS_ASSUME_NONNULL_END
