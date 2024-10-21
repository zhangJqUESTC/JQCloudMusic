//
//  DiscoveryFooterCell.h
//  JQCloudMusic
//  发现界面，底部，排序按钮布局cell
//  Created by zhangjq on 2024/10/20.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const DiscoveryFooterCellName = @"DiscoveryFooterCellName";

@interface DiscoveryFooterCell : BaseTableViewCell
/// 刷新按钮
@property (nonatomic, strong) QMUIButton *refreshView;

/// 自定义排序按钮
@property (nonatomic, strong) QMUIButton *customView;

/// 水平容器，用来放刷新按钮，后面提示文本
@property (nonatomic, strong) MyLinearLayout *orientationContainer;
@end

NS_ASSUME_NONNULL_END
