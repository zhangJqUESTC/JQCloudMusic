//
//  ResourceUtil.m
//  JQCloudMusic
//  资源工具类
//  Created by zhangjq on 2024/10/16.
//

#import "ResourceUtil.h"

@implementation ResourceUtil
+ (NSString *)resourceUri:(NSString *)data{
    return [NSString stringWithFormat:@"%@%@",RESOURCE_ENDPOINT,data];
}
@end
