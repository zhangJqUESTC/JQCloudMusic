//
//  LogFormater.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/30.
//

#import "LogFormater.h"
#import "SuperDateUtil.h"

@implementation LogFormater
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{
    NSString *logLevel;
       
   //判断日志等级；转为字符串
   switch (logMessage->_flag) {
       case DDLogFlagError    : logLevel = @"E"; break;
       case DDLogFlagWarning  : logLevel = @"W"; break;
       case DDLogFlagInfo     : logLevel = @"I"; break;
       case DDLogFlagDebug    : logLevel = @"D"; break;
       default                : logLevel = @"V"; break;
   }
   
   return [NSString stringWithFormat:@"%@ %@ %@ %@", [SuperDateUtil yearMonthDayHourMinuteSecondMillisecond:logMessage->_timestamp],logLevel,logMessage->_tag, logMessage->_message];
}
@end
