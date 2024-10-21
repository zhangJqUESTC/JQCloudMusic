//
//  SongData.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/20.
//

#import "SuperBase.h"
#import "Song.h"
NS_ASSUME_NONNULL_BEGIN

@interface SongData : SuperBase
/// 列表
/// 类型为：Song
@property (nonatomic, strong) NSArray *datum;
@end

NS_ASSUME_NONNULL_END
