//
//  Sheet.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/17.
//

#import "SuperCommon.h"
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface Sheet : SuperCommon
// 歌单标题
@property (nonatomic, strong) NSString *title;

/// 歌单封面
@property (nonatomic, strong) NSString *icon;

/// 点击数
@property (nonatomic, assign) int clicksCount;

/// 收藏数
@property (nonatomic, assign) int collectsCount;

/// 评论数
@property (nonatomic, assign) int commentsCount;

/// 音乐数量
@property (nonatomic, assign) int songsCount;

/// 歌单创建者
@property (nonatomic, strong) User *user;

/// 歌曲列表
@property (nonatomic, strong) NSArray *songs;
@end

NS_ASSUME_NONNULL_END
