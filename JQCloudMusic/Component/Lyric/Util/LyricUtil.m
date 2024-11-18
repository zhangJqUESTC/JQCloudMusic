//
//  LyricUtil.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import "LyricUtil.h"

@implementation LyricUtil
+(NSInteger)getLineNumber:(Lyric *)lyric progress:(float)progress{
    if (lyric==nil || [lyric.datum count]==0) {
        //列表不能为空
        
        //抛出异常
        @throw [NSException exceptionWithName:@"Lyrics cannot be blank" reason:nil userInfo:nil];
    }
    
    //转为毫秒
    progress=progress*1000;
    
    //倒序遍历每一行歌词
    for (unsigned long i=[lyric.datum count]-1; i>0; i--) {
        LyricLine *line=[lyric.datum objectAtIndex:i];
        if (progress>=line.startTime) {
            //如果当前时间正好大于等于该行开始时间
            //就是该行
            return i;
        }
    }
    
    //默认第0行
    return 0;
}

+ (NSInteger)getWordIndex:(LyricLine *)line progress:(float)progress{
    //转为毫秒
    progress=progress*1000;
    
    //这一行的开始时间
    long startTime = line.startTime;
    
    //循环所有字
    for (int i=0;i<[line.wordDurations count];i++) {
        NSNumber *number=line.wordDurations[i];
        
        //累加时间
        startTime=startTime+[number intValue];
        if (progress<startTime) {
            //如果进度小于累加的时间
            //就是这个索引
            return i;
        }
    }
    
    //默认值
    return -1;
}

+ (NSInteger)getWordPlayedTime:(LyricLine *)line progress:(float)progress{
    //转为毫秒
    progress=progress*1000;
    
    long startTime = line.startTime;
    for (int i=0;i<[line.wordDurations count];i++) {
        NSNumber *number=line.wordDurations[i];
        
        //毫秒
        startTime=startTime+[number intValue];
        if (progress<startTime) {
            //计算当前字已经播放的时间
            return [number intValue]-(startTime-progress);
        }
    }
    
    return -1;
}

/**
 * 获取当前时间对应的歌词行
 */
+(LyricLine *)getLyricLine:(Lyric *)data progress:(float)progress{
    //获取当前时间的行
    unsigned long lineNumber = [self getLineNumber:data progress:progress];
    
    //获取当前时间歌词行
    return data.datum[lineNumber];
}

@end
