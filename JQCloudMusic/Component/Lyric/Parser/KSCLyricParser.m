//
//  KSCLyricParser.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import "KSCLyricParser.h"

@implementation KSCLyricParser

+ (Lyric *)parse:(NSString *)data{
    Lyric *result=[[Lyric alloc] init];
    result.isAccurate=YES;
    
    result.datum=[[NSMutableArray alloc]init];
    
    //;拆分
    NSArray *strings = [data componentsSeparatedByString:@";"];
    
    NSString *line=nil;
    LyricLine *lyricLine=nil;
    for (int i=0; i<[strings count]; i++) {
        //每一行歌词
        line=strings[i];
        
        //解析每一行给次
        lyricLine=[self parserLine:line];
        if (lyricLine!=nil) {
            [result.datum addObject:lyricLine];
        }
    }
    return result;
}

//解析每一行歌词
//例如：karaoke.add('00:27.487', '00:32.068', '一时失志不免怨叹', '347,373,1077,320,344,386,638,1096');
+ (LyricLine *)parserLine:(NSString *)line{
    line = [line trim];
    
    LyricLine *lyricLine= nil;
    if ([line hasPrefix:@"karaoke.add("]) {
        lyricLine=[[LyricLine alloc] init];
        
        //歌词开始，过滤了前面的元数据
        //移除开始位置"karaoke.add('"字符串
        //移除后面的');
        line = [line substringWithRange:NSMakeRange(13, line.length-13-4)];
        
        //', '拆分
        NSArray *comands = [line componentsSeparatedByString:@"', '"];
        
        //开始时间
        lyricLine.startTime=[SuperDateUtil parseToInt:comands[0]];
        
        //结束时间
        lyricLine.endTime=[SuperDateUtil parseToInt:comands[1]];
        
        //歌词
        NSString *lyricString=comands[2];
        
        //将歌词拆分为单个字
        lyricLine.words=[self lyricWords:lyricString];
        
        if ([lyricString hasPrefix:@"["]) {
            //英文
            
            //整行歌词
            lyricLine.data=[lyricLine.words componentsJoinedByString:@" "];;
        } else {
            //整行歌词
            lyricLine.data=lyricString;
        }

        //每个字时间
        lyricLine.wordDurations=[[NSMutableArray alloc] init];
        
        NSString *lyricTimeString=comands[3];
        NSArray *lyricTimeWords = [lyricTimeString componentsSeparatedByString:@","];
        
        //将每个元素转为int,为了后面方便计算
        for (NSString *time in lyricTimeWords) {
            [lyricLine.wordDurations addObject: [NSNumber numberWithInt:[time intValue]]];
        }
        
    }
    return lyricLine;
}


/**
 将一行字符串，拆分为单个字
 
 @param line line description
 @return 拆分后的数组
 */
+ (NSMutableArray *)lyricWords:(NSString *)line {
    NSMutableArray * lineLyricsList = [[NSMutableArray alloc] init];
    NSString *temp = @"";
    BOOL isEnter = NO;
    
    //循环字符串，每个字符
    for(int i = 0; i < [line length]; i++)
    {
        NSString *c = [line substringWithRange:NSMakeRange(i, 1)];
        if ((![c isEqualToString:@"["])&&(![c isEqualToString:@"]"])) {
            if (isEnter) {
                temp = [NSString stringWithFormat:@"%@%@",temp,c];
            } else {
                [lineLyricsList addObject:c];
            }
        } else if ([c isEqualToString:@"["]) {
            isEnter = YES;
        } else if ([c isEqualToString:@"]"]) {
            isEnter = NO;
            [lineLyricsList addObject:temp];
            temp = @"";
        } else {
            temp = [NSString stringWithFormat:@"%@%@",temp,c];
        }
    }
    return lineLyricsList;
}

@end
