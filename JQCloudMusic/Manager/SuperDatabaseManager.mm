//
//  SuperDatabaseManager.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/12.
//

#import "SuperDatabaseManager.h"
#import <WCDBObjc/WCDBObjc.h>
#import "SearchHistory+WCTTableCoding.h"
#import "Song+WCTTableCoding.h"


//当前类日志Tag
static NSString * const SuperDatabaseManagerTag = @"SuperDatabaseManager";

@interface SuperDatabaseManager()

/// 数据库对象
@property(nonatomic, strong) WCTDatabase *database;

@end

@implementation SuperDatabaseManager
static SuperDatabaseManager *sharedInstance = nil;
/// 获取单例对象
+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[SuperDatabaseManager alloc] init];
        }
    });
    return sharedInstance;
}


- (instancetype)init{
    self=[super init];
    if(self){
        [self innerInit];
        [self initTable];
    }
    return self;
}

- (void)innerInit{
    //创建数据库
    //获取沙盒根目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    //数据库名称，添加用户id，这样就隔离了不同用户数据
    //当然也可以数据中存用户id
    NSString *databaseName = [NSString stringWithFormat:@"%@.db",[PreferenceUtil getUserId]];

    // 数据库文件路径
    NSString *databasePath = [documentsPath stringByAppendingPathComponent:databaseName];

    LogDebugTag(SuperDatabaseManagerTag, @"database path %@",databasePath);

    //创建数据库
    self.database = [[WCTDatabase alloc] initWithPath:databasePath];
}

/// 创建表
- (void)initTable{
    BOOL result = [self.database createTable:SearchHistoryName withClass:SearchHistory.class];
    [self.database createTable:SongName withClass:Song.class];
}

/// 保存搜索历史
/// @param data data description
-(void)saveSearchHistory:(SearchHistory *)data{
    [self.database insertObject:data intoTable:SearchHistoryName];
}

/// 查询所有搜索历史列表
-(NSArray *)getSearchHistoryAll{
    return [self.database getObjectsOfClass:SearchHistory.class fromTable:SearchHistoryName limit:100];
}

/// 删除搜索历史
/// @param data data description
-(void)deleteSearchHistory:(SearchHistory *)data{
    [self.database deleteFromTable:SearchHistoryName
                             where:SearchHistory.title == data.title];
}

-(void)saveAllSong:(NSArray *)data{
    //将嵌套模型转为单独的字段
    [self convertLocal:data];

    [self.database insertObjects:data intoTable:SongName];
}

-(void)saveSong:(Song *)data{
    [data convertLocal];


    [self.database insertObject:data intoTable:SongName];
}

-(NSArray *)findPlayList{
    NSArray *results = [self.database getObjectsOfClass:[Song class]
                                               fromTable:SongName
                                                   where:Song.list == YES
                                                  orders:Song.createdAt.asOrder(WCTOrderedDescending)];
    [self localConvert:results];
    return results;
}

-(Song *)find:(NSString *)data{
    Song *result = [self.database getObjectOfClass:Song.class 
                                         fromTable:SongName
                                             where:Song.id==data];
    [result localConvert];
    return result;
}

/// 将嵌套模型转为单独的字段
/// @param data data description
-(void)convertLocal:(NSArray *)data{
    for (Song *it in data) {
        [it convertLocal];
    }
}

/// 将单独字段转为嵌套字段
/// @param data data description
-(void)localConvert:(NSArray *)data{
    for (Song *it in data) {
        [it localConvert];
    }
}
@end
