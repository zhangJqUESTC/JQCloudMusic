//
//  SearchHistory.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/12.
//

//腾讯开源的数据库
//官方使用文档：https://github.com/Tencent/wcdb/wiki/iOS+macOS%e4%bd%bf%e7%94%a8%e6%95%99%e7%a8%8b
#import <WCDBObjc/WCDBObjc.h>
#import "SearchHistory.h"

@implementation SearchHistory
//类文件定义绑定到数据库表的类
WCDB_IMPLEMENTATION(SearchHistory)

//类文件定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(title)
WCDB_SYNTHESIZE(createdAt)

//主键
WCDB_PRIMARY(title)

//索引
WCDB_INDEX("_index", title)
@end
