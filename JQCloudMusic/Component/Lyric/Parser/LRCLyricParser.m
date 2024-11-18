//
//  LRCLyricParser.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import "LRCLyricParser.h"

@implementation LRCLyricParser

+ (Lyric *)parse:(NSString *)data{
    Lyric *result=[[Lyric alloc] init];
    result.isAccurate=NO;
    
    result.datum=[[NSMutableArray alloc] init];
    
    //\n拆分
    NSArray *strings = [data componentsSeparatedByString:@"\n"];
    
    NSString *line=nil;
    LyricLine *lyricLine=nil;
    for (int i=0; i<[strings count]; i++) {
        //每一行歌词
        line=strings[i];
        
        //解析每一行
        lyricLine=[self parserLine:line];
        if (lyricLine!=nil) {
            //添加到列表中
            [result.datum addObject:lyricLine];
        }
    }
    return result;
}

//解析每一行歌词
//例如：[00:00.300]爱的代价 - 李宗盛
+ (LyricLine *)parserLine:(NSString *)line{
    line = [line trim];
    
    LyricLine *lyricLine= nil;
    if ([line hasPrefix:@"[0"]) {
        lyricLine=[[LyricLine alloc] init];
        
        //歌词开始，过滤了前面的元数据
        //移除开始位置[字符串
        line = [line substringFromIndex:1];
        
        //]拆分
        NSArray *comands = [line componentsSeparatedByString:@"]"];
        
        //开始时间
        lyricLine.startTime=[SuperDateUtil parseToInt:comands[0]];
        
        //歌词
        lyricLine.data=comands[1];
    }
    return lyricLine;
}

@end
