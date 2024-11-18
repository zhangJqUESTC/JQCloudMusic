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

/**
 将float秒（3.867312）格式化为：150:11
 @return return value description
 */
+ (NSString *)second2MinuteSecond:(float)data;

+(int)parseToInt:(NSString *)data;
@end

NS_ASSUME_NONNULL_END
