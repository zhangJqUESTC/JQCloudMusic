//
//  LyricParser.h
//  JQCloudMusic
//  歌词解析器
//  Created by zhangjq on 2024/11/18.
//

#import <Foundation/Foundation.h>
#import "Lyric.h"

NS_ASSUME_NONNULL_BEGIN

@interface LyricParser : NSObject
+ (Lyric *)parse:(int)style data:(NSString *)data;
@end

NS_ASSUME_NONNULL_END
