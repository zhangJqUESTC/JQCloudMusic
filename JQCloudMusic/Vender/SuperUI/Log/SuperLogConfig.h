//
//  SuperLogConfig.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/29.
//

#ifndef SuperLogConfig_h
#define SuperLogConfig_h

//默认日志TAG
static NSString * const DEFAULT_LOG_TAG = @"JQCloudMusic";

//日志级别
#ifdef DEBUG
    //调试状态下，日志级别为debug
    static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
    //其他情况，为警告
    static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

//自定义日志宏，目的是更符合业务规则；以后换框架也方便
//使用默认日志TAG，使用方法如下：
//LogVerbose("Ixuea Verbose")
//LogDebug("Ixuea Debug")
//LogInfo("Ixuea Info")
//LogWarn("Ixuea Warn")
//LogError("Ixuea Error")

#define LogError(frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError,   0, DEFAULT_LOG_TAG, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define LogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, DEFAULT_LOG_TAG, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define LogInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    0, DEFAULT_LOG_TAG, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define LogDebug(frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, DEFAULT_LOG_TAG, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

//可以传递TAG，定义相同名，但参数不同比较麻烦，所以这里定义不同的名称
//使用方法如下：
//LogVerboseTag(@"TAG",@"Ixuea Verbose")
//LogDebugTag(@"TAG",@"Ixuea Debug")
//LogInfoTag(@"TAG",@"Ixuea Info")
//LogWarnTag(@"TAG",@"Ixuea Warn")
//LogErrorTag(@"TAG",@"Ixuea Error")

#define LogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, DEFAULT_LOG_TAG, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define LogErrorTag(tag, frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError,   0, tag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define LogWarnTag(tag, frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, tag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define LogInfoTag(tag, frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    0, tag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define LogDebugTag(tag, frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, tag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define LogVerboseTag(tag, frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, tag, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)



#endif /* SuperLogConfig_h */
