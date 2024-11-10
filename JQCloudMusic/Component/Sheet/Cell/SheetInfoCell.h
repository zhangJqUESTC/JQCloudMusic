//
//  SheetInfoCell.h
//  JQCloudMusic
//  歌单详情界面歌单的信息Cell
//  Created by zhangjq on 2024/11/10.
//

#import "BaseTableViewCell.h"
#import "Sheet.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const SheetInfoCellName = @"SheetInfoCellName";

@interface SheetInfoCell : BaseTableViewCell
/// 封面
@property (nonatomic, strong) UIImageView *iconView;

/// 标题
@property (nonatomic, strong) UILabel *titleView;

/// 头像
@property (nonatomic, strong) UIImageView *avatarView;

/// 昵称
@property (nonatomic, strong) UILabel *nicknameView;

/// 描述
@property (nonatomic, strong) UILabel *detailView;

//快捷按钮
@property (nonatomic, strong) QMUIButton *collectCountView;
@property (nonatomic, strong) QMUIButton *commentCountView;
@property (nonatomic, strong) QMUIButton *shareCountView;


-(void)bind:(Sheet *)data;
@end

NS_ASSUME_NONNULL_END
