//
//  SuperBase+MJExtension.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/6.
//

//JSON解析框架
#import <MJExtension/MJExtension.h>
#import "SuperBase+MJExtension.h"

@implementation SuperBase (MJExtension)
/// 属性映射规则
/// @param propertyName <#propertyName description#>
+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    // nickName -> nick_name
    NSString *result=[propertyName mj_underlineFromCamel];
    return [result isEqualToString:@"default_address"] ? @"default" : result;
}
@end
