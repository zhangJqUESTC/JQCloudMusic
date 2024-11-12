//
//  DataUtil.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/12.
//

#import <Foundation/Foundation.h>
#import "Song.h"
NS_ASSUME_NONNULL_BEGIN

@interface DataUtil : NSObject
/// 更改是否在播放列表字段
/// @param data data description
/// @param inList inList description
+(void)changePlayListFlag:(NSArray *)data inList:(BOOL)inList;

/// 处理消息
/// @param data data description
+(NSArray *)processMessage:(NSArray *)data;
@end

NS_ASSUME_NONNULL_END
