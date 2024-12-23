//
//  BaseMainController.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/20.
//

#import "BasePlayerController.h"


NS_ASSUME_NONNULL_BEGIN

@interface BaseMainController : BasePlayerController
/// 搜索按钮
@property(nonatomic, strong) QMUIButton *searchButton;

/// 搜索按钮点击
/// @param sender sender description
-(void)onSearchClick:(QMUIButton *)sender;
@end

NS_ASSUME_NONNULL_END
