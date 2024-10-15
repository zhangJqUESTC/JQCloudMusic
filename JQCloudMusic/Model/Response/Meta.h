//
//  Meta.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/15.
//

#import "SuperBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface Meta : SuperBase
/// 有多少条
@property (nonatomic, assign) int total;

/// 有多少页
@property (nonatomic, assign) int pages;

/// 当前每页显示多少条
@property (nonatomic, assign) int size;

/// 当前页
@property (nonatomic, assign) int page;

/// 下一页
@property (nonatomic, assign) int next;

/// 获取下一页
+(int)nextPage:(Meta *)data;
@end

NS_ASSUME_NONNULL_END
