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
@end
