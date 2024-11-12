//
//  SuperDatabaseManager.h
//  JQCloudMusic
//  数据库管理器
//  主要是对外提供更高层次接口，例如：查询音乐，保存音乐

//  Created by zhangjq on 2024/11/12.
//

#import <Foundation/Foundation.h>
#import "SearchHistory.h"
#import "Song.h"


NS_ASSUME_NONNULL_BEGIN

@interface SuperDatabaseManager : NSObject
// 获取单例对象
+(instancetype)shared;
/// 保存搜索历史
/// @param data data description
-(void)saveSearchHistory:(SearchHistory *)data;

/// 查询所有搜索历史列表
-(NSArray *)getSearchHistoryAll;

/// 删除搜索历史
/// @param data data description
-(void)deleteSearchHistory:(SearchHistory *)data;

/// 保存所有音乐
/// @param data data description
-(void)saveAllSong:(NSArray *)data;

/// 保存音乐
/// @param data data description
-(void)saveSong:(Song *)data;

/// 查询播放列表
-(NSArray *)findPlayList;

/// 根据id查询
/// @param data <#data description#>
-(Song *)find:(NSString *)data;
@end

NS_ASSUME_NONNULL_END
