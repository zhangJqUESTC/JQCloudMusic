//
//  LyricParser.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import "LyricParser.h"
#import "KSCLyricParser.h"
#import "LRCLyricParser.h"

@implementation LyricParser

+ (Lyric *)parse:(int)style data:(NSString *)data{
    switch (style) {
        case VALUE10:
            return [KSCLyricParser parse:data];
        default:
            //默认解析LRC歌词
            return [LRCLyricParser parse:data];
            
    }
}

@end
