//
//  DataUtil.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/12.
//

#import "DataUtil.h"

@implementation DataUtil
+(void)changePlayListFlag:(NSArray *)data inList:(BOOL)inList{
    for (Song *song in data) {
        song.list = inList;
    }
}
@end
