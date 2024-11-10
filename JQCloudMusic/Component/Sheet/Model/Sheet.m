//
//  Sheet.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/17.
//

#import "Sheet.h"

@implementation Sheet
- (instancetype)init{
    if (self=[super init]) {
        //设置数组的解析对象
        //如果不设置，默认为NSDictionary
        [Sheet mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"songs" : @"Song"
            };
        }];
    }
    return self;
}
@end
