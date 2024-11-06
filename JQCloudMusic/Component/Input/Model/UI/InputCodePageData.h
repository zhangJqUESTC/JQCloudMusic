//
//  InputCodePageData.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/6.
//

#import "SuperBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface InputCodePageData : SuperBase
/// 类型，主要是表示做什么
@property(nonatomic, assign) ListStyle style;

@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *email;
@end

NS_ASSUME_NONNULL_END
