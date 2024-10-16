//
//  BannerClickEvent.h
//  JQCloudMusic
//  发现界面banner点击事件，也可以用delegate实现
//  Created by zhangjq on 2024/10/16.
//

#import <Foundation/Foundation.h>
//发布订阅框架

#import "Ad.h"
NS_ASSUME_NONNULL_BEGIN

@interface BannerClickEvent : NSObject<QTEvent>

//可以携带任意数据
@property (nonatomic, strong) Ad *data;
@end

NS_ASSUME_NONNULL_END
