//
//  SearchHistory+WCTTableCoding.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/12.
//
#import <WCDBObjc/WCDBObjc.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistory (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(title)
WCDB_PROPERTY(createdAt)
@end

NS_ASSUME_NONNULL_END
