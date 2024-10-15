//
//  SuperCommon.h
//  JQCloudMusic
//  
//  Created by zhangjq on 2024/10/15.
//

#import "SuperBaseId.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuperCommon : SuperBaseId
/// 创建时间
@property (nonatomic, strong) NSString *createdAt;

/// 更新时间
@property (nonatomic, strong) NSString *updatedAt;

@property (nonatomic, strong) NSString *detail;
@end

NS_ASSUME_NONNULL_END
