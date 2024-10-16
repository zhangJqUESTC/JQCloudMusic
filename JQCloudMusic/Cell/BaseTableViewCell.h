//
//  BaseTableViewCell.h
//  JQCloudMusic
//  通用tableviewCell
//  Created by zhangjq on 2024/10/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell
//对于需要动态评估高度的UITableViewCell来说可以把布局视图暴露出来。用于高度评估和边界线处理。以及事件处理的设置。
@property (nonatomic, strong) MyBaseLayout *container;

/// 找控件
- (void)initViews;

/// 设置数据
- (void)initDatum;

/// 设置监听器
- (void)initListeners;

/// 获取根容器布局方向
-(MyOrientation)getContainerOrientation;
@end

NS_ASSUME_NONNULL_END
