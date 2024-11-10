//
//  SongCell.h
//  JQCloudMusic
//  单曲cell
//  Created by zhangjq on 2024/11/7.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const SongCellName = @"SongCellName";

@interface SongCell : BaseTableViewCell
/// 索引
@property (nonatomic, strong) UILabel *indexView;

/// 标题
@property (nonatomic, strong) UILabel *titleView;

/// 下载完成后图标
@property (nonatomic, strong) UIImageView *downloadedView;

/// 信息
@property (nonatomic, strong) UILabel *infoView;

- (void)bind:(Song *)data;
@end

NS_ASSUME_NONNULL_END
