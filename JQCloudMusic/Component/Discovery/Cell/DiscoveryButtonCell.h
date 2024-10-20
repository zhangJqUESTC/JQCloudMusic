//
//  DiscoveryButtonCell.h
//  JQCloudMusic
//  发现界面的快捷键按钮
//  Created by zhangjq on 2024/10/17.
//

#import "BaseTableViewCell.h"
#import "ButtonData.h"
NS_ASSUME_NONNULL_BEGIN

static NSString * const DiscoveryButtonCellName = @"DiscoveryButtonCellName";

@interface DiscoveryButtonCell : BaseTableViewCell
/// 也可以通过水平CollectionView实现
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MyBaseLayout *contentContainer;

- (void)bind:(ButtonData *)data;
@end

NS_ASSUME_NONNULL_END
