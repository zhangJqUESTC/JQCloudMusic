//
//  CodeRequest.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/6.
//

#import "SuperBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CodeRequest : SuperBase
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *email;

/// 如果发送频繁了，也可以邀请发送验证码时，传递图形验证码
@property(nonatomic, strong) NSString *code;
@end

NS_ASSUME_NONNULL_END
