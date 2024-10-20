//
//  IconTitleButtonData.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/17.
//

#import "IconTitleButtonData.h"

@implementation IconTitleButtonData
+ (instancetype)withTitle:(NSString *)title icon:(UIImage *)icon{
    IconTitleButtonData *result = [IconTitleButtonData new];
    
    result.title=title;
    result.icon=icon;
    
    return result;
}
@end
