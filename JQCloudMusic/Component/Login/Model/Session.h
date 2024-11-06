//
//  Session.h
//  JQCloudMusic
//  登录成功后返回的信息模型
//  Created by zhangjq on 2024/11/5.
//

#import "SuperBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface Session : SuperBase
/// 用户Id
@property(nonatomic, strong) NSString *userId;

/// 登录后的Session
@property(nonatomic, strong) NSString *session;

/// 聊天token
@property(nonatomic, strong) NSString *chatToken;
@end

NS_ASSUME_NONNULL_END
