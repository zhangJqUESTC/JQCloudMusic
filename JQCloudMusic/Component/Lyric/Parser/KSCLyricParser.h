//
//  KSCLyricParser.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import "SuperBase.h"
#import "Lyric.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSCLyricParser : SuperBase
+ (Lyric *)parse:(NSString *)data;
@end

NS_ASSUME_NONNULL_END
