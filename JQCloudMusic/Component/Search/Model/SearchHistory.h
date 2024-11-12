//
//  SearchHistory.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/12.
//

#import "SuperBase.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const SearchHistoryName = @"SearchHistory";

@interface SearchHistory : SuperBase 
/// 标题
@property (nonatomic, strong) NSString *title;

/// 创建时间
@property (nonatomic, assign) NSInteger createdAt;

@end

NS_ASSUME_NONNULL_END
