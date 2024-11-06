//
//  SuperRegularUtil.h
//  JQCloudMusic
//  正则表达式相关
//  Created by zhangjq on 2024/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperRegularUtil : NSObject
/// 是否符合手机号格式
/// @param data <#data description#>
+(BOOL)isPhone:(NSString *)data;

/// 是否符合邮箱格式
/// @param data <#data description#>
+(BOOL)isEmail:(NSString *)data;
@end

NS_ASSUME_NONNULL_END
