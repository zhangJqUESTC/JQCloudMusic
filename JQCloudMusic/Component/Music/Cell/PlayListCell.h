//
//  PlayListCell.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/13.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayListCell : BaseTableViewCell
/// 删除按钮点击block
@property (nonatomic, strong, nullable) SuperClick deleteBlock;

/// 标题
@property (nonatomic, strong) UILabel *titleView;

@property (nonatomic, strong) QMUIButton *deleteView;

-(void)bind:(Song *)data;
@end

NS_ASSUME_NONNULL_END
