//
//  SongGroupHeaderView.h
//  JQCloudMusic
//  歌单详情，音乐列表分组view
//  Created by zhangjq on 2024/11/10.
//

#import "BaseTableViewHeaderFooterView.h"
#import "SongGroupData.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const SongGroupHeaderViewName = @"SongGroupHeaderViewName";

@interface SongGroupHeaderView : BaseTableViewHeaderFooterView
/// 播放所有点击block
@property (nonatomic, strong, nullable) SuperClick playAllClickBlock;

/// 音乐数量view
@property (nonatomic, strong) UILabel *countView;

-(void)bind:(SongGroupData *)data;
@end

NS_ASSUME_NONNULL_END
