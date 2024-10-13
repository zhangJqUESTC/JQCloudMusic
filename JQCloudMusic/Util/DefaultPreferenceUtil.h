//
//  DefaultPreferenceUtil.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DefaultPreferenceUtil : NSObject
/// 是否同意了用户条款
+(BOOL)isAcceptTermsServiceAgreement;

/// 设置同意了用户协议
/// @param data data description
+(void)setAcceptTermsServiceAgreement:(BOOL)data;
@end

NS_ASSUME_NONNULL_END
