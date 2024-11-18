//
//  SuperDateUtil.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/11.
//

#import "SuperDateUtil.h"

@implementation SuperDateUtil
+(NSInteger)getCurrentYear{
    NSDate *date = [NSDate new];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *d = [cal components:unitFlags fromDate:date];
    NSInteger year = [d year];
    return year;
}

+(NSInteger)currentDay{
    //当前日期
    NSDate *date = [NSDate date];
    
    //这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date];
    
    return [d day];
}

+ (NSString *)yearMonthDayHourMinuteSecondMillisecond:(NSDate *)data{
    NSDateFormatter *dateFomatter =[[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *result=[dateFomatter stringFromDate:data];
    return result;
}

+ (NSString *)second2MinuteSecond:(float)data{
    int minute=data/60;
    int second=((int)data)%60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}

+(int)parseToInt:(NSString *)data{
    //将:替换为.
    data=[data stringByReplacingOccurrencesOfString:@":" withString:@"."];
    
    //.拆分
    NSArray *strings = [data componentsSeparatedByString:@"."];
    int m=[strings[0] intValue];
    int s=[strings[1] intValue];
    int ms=[strings[2] intValue];
    
    return (m*60+s)*1000+ms;
}

@end
