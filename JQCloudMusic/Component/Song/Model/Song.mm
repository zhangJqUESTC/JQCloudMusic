//
//  Song.m
//  JQCloudMusic
//  单曲模型
//  Created by zhangjq on 2024/10/20.
//

#import <WCDBObjc/WCDBObjc.h>
#import "Song.h"


@implementation Song
//类文件定义绑定到数据库表的类
WCDB_IMPLEMENTATION(Song)

//类文件定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(id)
WCDB_SYNTHESIZE(title)
WCDB_SYNTHESIZE(icon)
WCDB_SYNTHESIZE(uri)
WCDB_SYNTHESIZE(clicksCount)
WCDB_SYNTHESIZE(commentsCount)
WCDB_SYNTHESIZE(style)
WCDB_SYNTHESIZE(path)
WCDB_SYNTHESIZE(lyric)
WCDB_SYNTHESIZE(duration)
WCDB_SYNTHESIZE(progress)
WCDB_SYNTHESIZE(list)
WCDB_SYNTHESIZE(detail)
WCDB_SYNTHESIZE(singerId)
WCDB_SYNTHESIZE(singerNickname)
WCDB_SYNTHESIZE(singerIcon)
WCDB_SYNTHESIZE(createdAt)
WCDB_SYNTHESIZE(updatedAt)

//主键
WCDB_PRIMARY(id)

//索引
WCDB_INDEX("_index", list)

-(void)convertLocal{
    _singerId = _singer.id;
    _singerNickname = _singer.nickname;
    _singerIcon = _singer.icon;
}

-(void)localConvert{
    User *singer = [User new];
    singer.id = _singerId;
    singer.nickname = _singerNickname;
    singer.icon = _singerIcon;
    _singer = singer;
}
@end
