//
//  BaseRelativeLayout.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/31.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseRelativeLayout : MyRelativeLayout
/// 找控件
- (void)initViews;


/// 设置数据
- (void)initDatum;

/// 设置监听器
- (void)initListeners;
@end

NS_ASSUME_NONNULL_END
