//
//  SongSmallCell.h
//  JQCloudMusic
//  迷你音乐控制器cell
//  Created by zhangjq on 2024/11/13.
//

#import "BaseCollectionViewCell.h"
#import "Song.h"
#import "LyricLineView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SongSmallCell : BaseCollectionViewCell
/// 封面
@property (nonatomic, strong) UIImageView *iconView;

/// 标题
@property (nonatomic, strong) UILabel *titleView;

@property (nonatomic, strong) MyLinearLayout *rightContainer;

/// 歌词view
@property(nonatomic, strong) LyricLineView *lineView;

-(void)bind:(Song *)data;
@end

NS_ASSUME_NONNULL_END
