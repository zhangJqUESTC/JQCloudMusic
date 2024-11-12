//
//  Song+WCTTableCoding.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/12.
//

#import <WCDBObjc/WCDBObjc.h>
#import "Song.h"


NS_ASSUME_NONNULL_BEGIN

@interface Song (WCTTableCoding) <WCTTableCoding>
//头文件声明需要绑定到数据库表的字段
WCDB_PROPERTY(id)
WCDB_PROPERTY(title)
WCDB_PROPERTY(icon)
WCDB_PROPERTY(uri)
WCDB_PROPERTY(clicksCount)
WCDB_PROPERTY(commentsCount)
WCDB_PROPERTY(style)
WCDB_PROPERTY(path)
WCDB_PROPERTY(lyric)
WCDB_PROPERTY(duration)
WCDB_PROPERTY(progress)
WCDB_PROPERTY(list)
WCDB_PROPERTY(detail)
WCDB_PROPERTY(singerId)
WCDB_PROPERTY(singerNickname)
WCDB_PROPERTY(singerIcon)
WCDB_PROPERTY(createdAt)
WCDB_PROPERTY(updatedAt)
@end

NS_ASSUME_NONNULL_END
