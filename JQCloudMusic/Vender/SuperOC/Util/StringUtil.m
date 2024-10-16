//
//  StringUtil.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/16.
//

#import "StringUtil.h"

@implementation StringUtil
+ (BOOL)isBlank:(NSString *)data{
    if (!data) {
        return YES;
    }
    if ([data isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!data.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [data stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNotBlank:(NSString *)data{
    return ![self isBlank:data];
}
@end
