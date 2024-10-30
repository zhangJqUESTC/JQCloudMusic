//
//  SuperDateUtil.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/11.
//  日期工具类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperDateUtil : NSObject
/// 当前年
+ (NSInteger)getCurrentYear;
/// 当前年
+ (NSInteger)currentDay;
+ (NSString *)yearMonthDayHourMinuteSecondMillisecond:(NSDate *)data;
@end

NS_ASSUME_NONNULL_END
