//
//  SetPasswordPageData.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/6.
//

#import "SuperBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetPasswordPageData : SuperBase
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *code;
@end

NS_ASSUME_NONNULL_END
