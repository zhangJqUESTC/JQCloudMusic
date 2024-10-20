//
//  SheetCell.h
//  JQCloudMusic
//  歌单cell
//  Created by zhangjq on 2024/10/17.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const SheetCellName = @"SheetCellName";

@interface SheetCell : BaseCollectionViewCell

/// 封面
@property (nonatomic, strong) UIImageView *iconView;

/// 标题
@property (nonatomic, strong) UILabel *titleView;
- (void)bind:(Sheet *)data;
@end

NS_ASSUME_NONNULL_END
