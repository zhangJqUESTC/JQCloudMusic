//
//  SetPasswordController.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/6.
//

#import "BaseLoginController.h"
#import "SetPasswordPageData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetPasswordController : BaseLoginController
@property(nonatomic, strong) SetPasswordPageData *pageData;

+ (void)start:(UINavigationController *)controller data:(SetPasswordPageData *)data;
@end

NS_ASSUME_NONNULL_END
