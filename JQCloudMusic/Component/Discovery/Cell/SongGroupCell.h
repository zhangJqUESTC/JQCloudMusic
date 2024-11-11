//
//  SongGroupCell.h
//  JQCloudMusic
//  发现界面单曲组
//  Created by zhangjq on 2024/10/20.
//

#import "BaseTableViewCell.h"
#import "ItemTitleView.h"
#import "SongData.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const SongGroupCellName = @"SongGroupCellName";

@interface SongGroupCell : BaseTableViewCell
///// 点击block
@property void (^clickBlock)(Song *);

/// 标题控件
@property(nonatomic,strong) ItemTitleView *titleView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datum;

-(void)bind:(SongData *)data;
@end

NS_ASSUME_NONNULL_END
